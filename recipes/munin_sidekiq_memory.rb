cookbook_file File.join(node['munin']['basedir'], "plugin-conf.d/omnibus_gitlab_sidekiq_rss.conf") do
  notifies :restart, "service[munin-node]"
end

munin_plugin 'omnibus_gitlab_sidekiq_rss' do
  create_file true
  notifies :restart, "service[munin-node]"
end
