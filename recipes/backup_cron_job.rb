# Manage a gitlab backup cron job

backup_cron_job = node['omnibus-gitlab']['backup_cron_job']
options = ''

remote_file '/usr/local/bin/chronic' do
  source 'http://habilis.net/cronic/cronic'
  owner 'root'
  group 'root'
  checksum '43e257be51b40aa3d6f00aaa89df2a74cebfd35d594f26c9c440e588b4070fc7'
  mode '0755'
  action :create_if_missing
end


if backup_cron_job['skip'].any?
  options << " SKIP=#{backup_cron_job['skip'].join(',')}"
end

if backup_cron_job['silent']
  options << " CRON=1"
end

cron 'GitLab backup' do
  command "/usr/local/bin/chronic /opt/gitlab/bin/gitlab-rake gitlab:backup:create #{options}"
  hour backup_cron_job['hour']
  minute backup_cron_job['minute']
  weekday backup_cron_job['weekday']
  user backup_cron_job['user']
  action backup_cron_job['enable'] ? :create : :delete
end
