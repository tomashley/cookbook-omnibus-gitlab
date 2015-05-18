cookbook_file File.join(node['munin']['basedir'], "plugin-conf.d/omnibus_gitlab_redis.conf") do
  notifies :restart, "service[munin-node]"
end

cookbook_file File.join(node['munin']['plugin_dir'], "omnibus_gitlab_redis") do
  mode "0755"
  notifies :restart, "service[munin-node]"
end
munin_plugin 'redis_' do
  plugin "redis_socket_var_opt_gitlab_redis_redis.socket"
  notifies :restart, "service[munin-node]"
end
