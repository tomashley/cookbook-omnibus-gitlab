#
# Cookbook Name:: cookbook-omnibus-gitlab
# Recipe:: backup_cron_job
#
# Manage a gitlab backup cron job
#
# Copyright (C) 2016 GitLab Inc.
#
# All rights reserved - Do Not Redistribute
#

backup_cron_job = node['omnibus-gitlab']['backup_cron_job']
pre_command = backup_cron_job['pre_command']
options = ''

if backup_cron_job['skip'].any?
  options << " SKIP=#{backup_cron_job['skip'].join(',')}"
end

options << ' CRON=1' if backup_cron_job['silent']

cron 'GitLab backup' do
  command "#{pre_command}/opt/gitlab/bin/gitlab-rake gitlab:backup:create #{options}"
  hour backup_cron_job['hour']
  minute backup_cron_job['minute']
  weekday backup_cron_job['weekday']
  user backup_cron_job['user']
  action backup_cron_job['enable'] ? :create : :delete
end
