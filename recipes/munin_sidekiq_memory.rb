cookbook_file File.join(node['munin']['basedir'], "plugin-conf.d/omnibus_gitlab_sidekiq_rss") do
  source "omnibus_gitlab_sidekiq_rss.conf.erb"
  notifies :restart, "service[munin-node]"
end

cookbook_file File.join(node['munin']['plugin_dir'], 'omnibus_gitlab_sidekiq_rss') do
  mode "0755"
  notifies :restart, "service[munin-node]"
end
