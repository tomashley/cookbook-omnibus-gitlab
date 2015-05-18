port = node['omnibus-gitlab']['gitlab_rb']['redis']['port'] || 6379
bind = node['omnibus-gitlab']['gitlab_rb']['redis']['bind'] || "0.0.0.0"

cookbook_file File.join(node['munin']['plugin_dir'], "redis_") do
  mode "0755"
  notifies :restart, "service[munin-node]"
end

munin_plugin 'redis_' do
  plugin "redis_#{bind}_#{port}"
  notifies :restart, "service[munin-node]"
end
