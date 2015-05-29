# Manage a gitlab backup cron job

backup_cron_job = node['omnibus-gitlab']['backup_cron_job']
options = ''

if backup_cron_job['skip'].any?
  options << " SKIP=#{backup_cron_job['skip'].join(',')}"
end

if backup_cron_job['silent']
  options << " CRON=1"
end

cron 'GitLab backup' do
  command "/opt/gitlab/bin/gitlab-rake gitlab:backup:create #{options}"
  hour backup_cron_job['hour']
  minute backup_cron_job['minute']
  weekday backup_cron_job['weekday']
  user backup_cron_job['user']
  action backup_cron_job['enable'] ? :create : :delete
end
