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
data_bag_name = node['omnibus-gitlab']['data_bag']
data_bag_item = node.chef_environment
environment_secrets = Mash.new
if data_bag_name && search(data_bag_name, "id:#{data_bag_item}").any?
  environment_secrets = Chef::EncryptedDataBagItem.load(data_bag_name, data_bag_item)
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

gitlab_rb = node['omnibus-gitlab']['gitlab_rb'].merge(environment_secrets['omnibus-gitlab']['gitlab_rb'])
template "/etc/gitlab/gitlab.rb" do
  mode "0600"
  variables(gitlab_rb: gitlab_rb)
  notifies :run, 'execute[gitlab-ctl reconfigure]'
end

directory "/etc/gitlab/ssl" do
  mode "0700"
end

ssl = node['omnibus-gitlab']['ssl'].merge(environment_secrets['omnibus-gitlab']['ssl'])

file node['omnibus-gitlab']['gitlab_rb']['nginx']['ssl_certificate'] do
  content ssl['certificate']
  not_if { ssl['certificate'].nil? }
end

file node['omnibus-gitlab']['gitlab_rb']['nginx']['ssl_certificate_key'] do
  content ssl['private_key']
  not_if { ssl['private_key'].nil? }
  mode "0600"
end

# Run gitlab-ctl reconfigure if /etc/gitlab/gitlab.rb changed
execute "gitlab-ctl reconfigure" do
  action :nothing
end
