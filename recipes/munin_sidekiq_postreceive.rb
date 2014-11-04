template File.join(node['munin']['basedir'], "plugin-conf.d/omnibus_gitlab_sidekiq_postreceive.conf") do
  notifies :restart, "service[munin-node]"
  variables node['omnibus-gitlab']['munin_sidekiq_postreceive'].to_hash
end

cookbook_file File.join(node['munin']['plugin_dir'], "omnibus_gitlab_sidekiq_postreceive") do
  mode "0755"
  notifies :restart, "service[munin-node]"
end

munin_plugin 'omnibus_gitlab_sidekiq_postreceive' do
  notifies :restart, "service[munin-node]"
end
