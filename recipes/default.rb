#
# Cookbook Name:: cookbook-omnibus-gitlab
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

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

directory "/etc/gitlab" do
  mode "0700"
end

template "/etc/gitlab/gitlab.rb" do
  notifies :run, 'execute[gitlab-ctl reconfigure]'
end

execute "gitlab-ctl reconfigure" do
  action :nothing
end
