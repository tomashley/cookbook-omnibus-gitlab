# This enables the three NGINX Munin plugins found in
# https://github.com/jesseadams/munin/tree/master/files/default/plugins . At
# the moment, this will only work if you also tell omnibus-gitlab to actually
# serve up the http://localhost/nginx_status endpoint.
#
# In /etc/gitlab/gitlab.rb:
#
# nginx['custom_nginx_config'] = "server { listen 127.0.0.1:80; location /nginx_status { stub_status on; access_log off; allow 127.0.0.1; deny all; } }"
#
# Equivalently, using cookbook-omnibus-gitlab:
#
# "omnibus-gitlab": {
#   "gitlab_rb": {
#     "nginx": {
#        "custom_nginx_config": "server { listen 127.0.0.1:80; location /nginx_status { stub_status on; access_log     off; allow 127.0.0.1; deny all; } }"
#      }
#    }
#  }

%w{
  nginx_memory
  nginx_request
  nginx_status
}.each do |plugin|
  munin_plugin plugin do
    create_file true
  end
end
