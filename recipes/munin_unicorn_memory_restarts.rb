file File.join(node['munin']['basedir'], "plugin-conf.d/omnibus_gitlab_unicorn_memory_restarts.conf") do
  content "[omnibus_gitlab_unicorn_memory_restarts]\nuser root\n"
  notifies :restart, "service[munin-node]"
end

cookbook_file File.join(node['munin']['plugin_dir'], "omnibus_gitlab_unicorn_memory_restarts") do
  mode "0755"
  notifies :restart, "service[munin-node]"
end

munin_plugin 'omnibus_gitlab_unicorn_memory_restarts' do
  notifies :restart, "service[munin-node]"
end
