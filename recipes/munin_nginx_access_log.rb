cookbook_file File.join(node['munin']['basedir'], "plugin-conf.d/omnibus_gitlab_nginx_access.conf") do
  notifies :restart, "service[munin-node]"
end

cookbook_file File.join(node['munin']['plugin_dir'], "omnibus_gitlab_nginx_access") do
  mode "0755"
  notifies :restart, "service[munin-node]"
end

munin_plugin 'omnibus_gitlab_nginx_access' do
  notifies :restart, "service[munin-node]"
end
