cookbook_file File.join(node['munin']['basedir'], "plugin-conf.d/omnibus-gitlab-redis.conf") do
  notifies :restart, "service[munin-node]"
end

cookbook_file File.join(node['munin']['plugin_dir'], "omnibus-gitlab-redis") do
  mode "0755"
  notifies :restart, "service[munin-node]"
end

munin_plugin 'omnibus-gitlab-redis' do
  plugin "omnibus-gitlab-redis_socket_var_opt_gitlab_redis_redis.socket"
  notifies :restart, "service[munin-node]"
end
