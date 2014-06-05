template File.join(node['munin']['basedir'], "plugin-conf.d/multips_memory_sidekiq") do
  variables(node['omnibus-gitlab']['munin'].to_hash)
  notifies :restart, "service[munin-node]"
end

munin_plugin 'multips_memory' do
  plugin "multips_memory_sidekiq"
  notifies :restart, "service[munin-node]"
end
