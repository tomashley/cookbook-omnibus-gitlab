#
# Cookbook Name:: cookbook-omnibus-gitlab
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Fetch encrypted configuration settings (passwords, keys etc.) from an
# encrypted data bag
environment_secrets = OmnibusGitlab.environment_secrets_for_node(node)

pkg_base_url = node['omnibus-gitlab']['package']['base_url']
pkg_repo = node['omnibus-gitlab']['package']['repo']
package 'curl'

case node['platform_family']
when 'debian'
  execute "add #{pkg_base_url}/#{pkg_repo} apt repo" do
    command "curl #{pkg_base_url}/install/repositories/#{pkg_repo}/script.deb.sh | bash"
    creates "/etc/apt/sources.list.d/#{pkg_repo.sub('/','_')}.list"
  end

  package node['omnibus-gitlab']['package']['name'] do
    version node['omnibus-gitlab']['package']['version']
    notifies :run, 'execute[gitlab-ctl reconfigure]'
  end
when 'rhel'
  execute "add #{pkg_base_url}/#{pkg_repo} yum repo" do
    command "curl #{pkg_base_url}/install/repositories/#{pkg_repo}/script.rpm.sh | bash"
    creates "/etc/yum.repos.d/#{pkg_repo.sub('/','_')}.repo"
  end

  package node['omnibus-gitlab']['package']['name'] do
    version node['omnibus-gitlab']['package']['version']
    notifies :run, 'execute[gitlab-ctl reconfigure]'
    allow_downgrade true
  end
end

# Create /etc/gitlab and its contents
directory "/etc/gitlab"

environment_secrets['omnibus-gitlab'] ||= Hash.new
environment_secrets['omnibus-gitlab']['gitlab_rb'] ||= Hash.new
gitlab_rb = Chef::Mixin::DeepMerge.deep_merge(environment_secrets['omnibus-gitlab']['gitlab_rb'], node['omnibus-gitlab']['gitlab_rb'].to_hash)
template "/etc/gitlab/gitlab.rb" do
  mode "0600"
  variables(gitlab_rb: gitlab_rb)
  helper(:single_quote) { |value| value.nil? ? nil : "'#{value}'" }
  notifies :run, 'execute[gitlab-ctl reconfigure]'
end

file '/etc/gitlab/skip-auto-migrations' do
  if node['omnibus-gitlab']['skip_auto_migrations']
    action :create
  else
    action :delete
  end
end

directory "/etc/gitlab/ssl" do
  mode "0700"
end

environment_secrets['omnibus-gitlab'] ||= Hash.new
environment_secrets['omnibus-gitlab']['ssl'] ||= Hash.new
ssl = Chef::Mixin::DeepMerge.deep_merge(environment_secrets['omnibus-gitlab']['ssl'], node['omnibus-gitlab']['ssl'].to_hash)

file node['omnibus-gitlab']['gitlab_rb']['nginx']['ssl_certificate'] do
  content ssl['certificate']
  not_if { ssl['certificate'].nil? }
  notifies :run, 'bash[reload nginx configuration]'
end

file node['omnibus-gitlab']['gitlab_rb']['nginx']['ssl_certificate_key'] do
  content ssl['private_key']
  not_if { ssl['private_key'].nil? }
  mode "0600"
  notifies :run, 'bash[reload nginx configuration]'
end

file node['omnibus-gitlab']['gitlab_rb']['ci-nginx']['ssl_certificate'] do
  content ssl['ci_certificate']
  not_if { ssl['ci_certificate'].nil? }
  notifies :run, 'bash[reload nginx configuration]'
end

file node['omnibus-gitlab']['gitlab_rb']['ci-nginx']['ssl_certificate_key'] do
  content ssl['ci_private_key']
  not_if { ssl['ci_private_key'].nil? }
  mode "0600"
  notifies :run, 'bash[reload nginx configuration]'
end

# Run gitlab-ctl reconfigure if /etc/gitlab/gitlab.rb changed
execute "gitlab-ctl reconfigure" do
  action :nothing
end

# Reload NGINX if the SSL certificate or key has changed
bash "reload nginx configuration" do
  code <<-EOS
  if gitlab-ctl status nginx ; then
    gitlab-ctl hup nginx
  fi
  EOS
  action :nothing
end
