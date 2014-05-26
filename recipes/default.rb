#
# Cookbook Name:: cookbook-omnibus-gitlab
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

data_bag_name = node['omnibus-gitlab']['data_bag']
data_bag_item = node.chef_environment
if search(data_bag_name, "id:#{data_bag_item}").any?
  environment_secrets = data_bag_item(data_bag_name, data_bag_item)
  node.consume_attributes(environment_secrets)
end

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

directory "/etc/gitlab"

template "/etc/gitlab/gitlab.rb" do
  mode "0600"
  notifies :run, 'execute[gitlab-ctl reconfigure]'
end

execute "gitlab-ctl reconfigure" do
  action :nothing
end
