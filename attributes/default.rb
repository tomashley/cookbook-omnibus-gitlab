default['omnibus-gitlab']['package']['url'] = "https://downloads-packages.s3.amazonaws.com/ubuntu-12.04/gitlab_6.9.0-omnibus-1_amd64.deb"
default['omnibus-gitlab']['package']['sha256'] = "42e8224f8aa8689ba80380d036a3b367ffb63a85b5e447670a5233d888b85924"
default['omnibus-gitlab']['package']['repo'] = 'gitlab/gitlab-ce'
default['omnibus-gitlab']['package']['base_url'] = 'https://packages.gitlab.com'
default['omnibus-gitlab']['package']['name'] = 'gitlab-ce'
default['omnibus-gitlab']['package']['version'] = nil
default['omnibus-gitlab']['package']['timeout'] = nil

default['omnibus-gitlab']['data_bag'] = nil

default['omnibus-gitlab']['ssh']['host_keys'] = {} # hash of 'filename' => 'contents' pairs

default['omnibus-gitlab']['gitlab_rb']['nginx']['ssl_certificate'] = "/etc/gitlab/ssl/nginx.crt"
default['omnibus-gitlab']['gitlab_rb']['nginx']['ssl_certificate_key'] = "/etc/gitlab/ssl/nginx.key"
default['omnibus-gitlab']['gitlab_rb']['ci-nginx']['ssl_certificate'] = "/etc/gitlab/ssl/ci-nginx.crt"
default['omnibus-gitlab']['gitlab_rb']['ci-nginx']['ssl_certificate_key'] = "/etc/gitlab/ssl/ci-nginx.key"
default['omnibus-gitlab']['gitlab_rb']['mattermost-nginx']['ssl_certificate'] = "/etc/gitlab/ssl/mattermost-nginx.crt"
default['omnibus-gitlab']['gitlab_rb']['mattermost-nginx']['ssl_certificate_key'] = "/etc/gitlab/ssl/mattermost-nginx.key"
default['omnibus-gitlab']['gitlab_rb']['pages-nginx']['ssl_certificate'] = "/etc/gitlab/ssl/pages.crt"
default['omnibus-gitlab']['gitlab_rb']['pages-nginx']['ssl_certificate_key'] = "/etc/gitlab/ssl/pages.key"
default['omnibus-gitlab']['gitlab_rb']['registry-nginx']['ssl_certificate'] = "/etc/gitlab/ssl/registry.crt"
default['omnibus-gitlab']['gitlab_rb']['registry-nginx']['ssl_certificate_key'] = "/etc/gitlab/ssl/registry.key"

default['omnibus-gitlab']['ssl']['certificate'] = ''
default['omnibus-gitlab']['ssl']['private_key'] = ''
default['omnibus-gitlab']['ssl']['ci_certificate'] = ''
default['omnibus-gitlab']['ssl']['ci_private_key'] = ''
default['omnibus-gitlab']['ssl']['mattermost_certificate'] = ''
default['omnibus-gitlab']['ssl']['mattermost_private_key'] = ''
default['omnibus-gitlab']['ssl']['pages_certificate'] = ''
default['omnibus-gitlab']['ssl']['pages_private_key'] = ''
default['omnibus-gitlab']['ssl']['registry_certificate'] = ''
default['omnibus-gitlab']['ssl']['registry_private_key'] = ''

default['omnibus-gitlab']['skip_auto_migrations'] = false

default['omnibus-gitlab']['munin_sidekiq_postreceive']['window_size'] = 100

default['omnibus-gitlab']['backup_cron_job']['skip'] = []
default['omnibus-gitlab']['backup_cron_job']['silent'] = true
default['omnibus-gitlab']['backup_cron_job']['hour'] = '0'
default['omnibus-gitlab']['backup_cron_job']['minute'] = '30'
default['omnibus-gitlab']['backup_cron_job']['weekday'] = nil # defaults to '*', every day
default['omnibus-gitlab']['backup_cron_job']['user'] = 'root'
default['omnibus-gitlab']['backup_cron_job']['enable'] = true
