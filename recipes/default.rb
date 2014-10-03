#
# Cookbook Name:: cookbook-omnibus-gitlab
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Merge encrypted configuration settings (passwords, keys etc.) from an
# encrypted data bag
data_bag_name = node['omnibus-gitlab']['data_bag']
data_bag_item = node.chef_environment
if data_bag_name && search(data_bag_name, "id:#{data_bag_item}").any?
  environment_secrets = Chef::EncryptedDataBagItem.load(data_bag_name, data_bag_item).to_hash
  environment_secrets.delete("id")
  node.consume_attributes(environment_secrets)
end

# Download and install the package assigned to this node
pkg_source = node['omnibus-gitlab']['package']['url']
pkg_path = File.join(Chef::Config[:file_cache_path], File.basename(pkg_source))

remote_file pkg_path do
  source pkg_source
  checksum node['omnibus-gitlab']['package']['sha256']
end

case File.extname(pkg_source)
when ".deb"
  dpkg_package "gitlab" do
    source pkg_path
    notifies :run, 'execute[gitlab-ctl reconfigure]'
  end
else
  raise "Unsupported package format: #{pkg_source}"
end

# Create /etc/gitlab and its contents
directory "/etc/gitlab"

template "/etc/gitlab/gitlab.rb" do
  mode "0600"
  notifies :run, 'execute[gitlab-ctl reconfigure]'
end

directory "/etc/gitlab/ssl" do
  mode "0700"
end

ssl_certificate = node['omnibus-gitlab']['ssl']['certificate']
file node['omnibus-gitlab']['gitlab_rb']['nginx']['ssl_certificate'] do
  content ssl_certificate
  not_if { ssl_certificate.nil? }
  notifies :run, 'bash[reload nginx configuration]'
end

ssl_private_key = node['omnibus-gitlab']['ssl']['private_key']
file node['omnibus-gitlab']['gitlab_rb']['nginx']['ssl_certificate_key'] do
  content ssl_private_key
  not_if { ssl_private_key.nil? }
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
