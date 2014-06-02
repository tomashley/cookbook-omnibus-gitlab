package 'libdbd-pg-perl'

database = node['omnibus-gitlab']['gitlab_rb']['gitlab-rails']['db_database'] || "gitlabhq_production"
port = node['omnibus-gitlab']['gitlab_rb']['postgresql']['port'] || 5432
user = node['omnibus-gitlab']['gitlab_rb']['postgresql']['username'] || "gitlab-psql"

template File.join(node['munin']['basedir'], "plugin-conf.d/override-postgres") do
  variables(port: port, user: user)
  notifies :restart, "service[munin-node]"
end

munin_plugin "postgres_connections_" do
  plugin "postgres_connections_#{database}"
  notifies :restart, "service[munin-node]"
end

munin_plugin "postgres_size_" do
  plugin "postgres_size_#{database}"
  variables({port: port, user: user})
  notifies :restart, "service[munin-node]"
end
