default['omnibus-gitlab']['package']['url'] = "https://downloads-packages.s3.amazonaws.com/ubuntu-12.04/gitlab_6.9.0-omnibus-1_amd64.deb"
default['omnibus-gitlab']['package']['sha256'] = "42e8224f8aa8689ba80380d036a3b367ffb63a85b5e447670a5233d888b85924"

default['omnibus-gitlab']['data_bag'] = nil

default['omnibus-gitlab']['ssl']['certificate'] = nil
default['omnibus-gitlab']['ssl']['private_key'] = nil

default['omnibus-gitlab']['gitlab_rb']['nginx']['ssl_certificate'] = "/etc/gitlab/ssl/nginx.crt"
default['omnibus-gitlab']['gitlab_rb']['nginx']['ssl_certificate_key'] = "/etc/gitlab/ssl/nginx.key"

default['omnibus-gitlab']['munin']['sidekiq_process_regex'] = "sidekiq.2"
