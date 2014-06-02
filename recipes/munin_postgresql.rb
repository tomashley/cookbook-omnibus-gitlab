package 'libdbd-pg-perl'

database = node['omnibus-gitlab']['gitlab_rb']['gitlab-rails']['db_database'] || "gitlabhq_production"
port = node['omnibus-gitlab']['gitlab_rb']['postgresql']['port'] || 5432
user = node['omnibus-gitlab']['gitlab_rb']['postgresql']['username'] || "gitlab-psql"

template File.join(node['munin']['basedir'], "plugin-conf.d/override-postgres") do
  variables(port: port, user: user)
  notifies :restart, "service[munin-node]"
end

%w{
  postgres_scans_
  postgres_cache_
  postgres_size_
  postgres_transactions_
  postgres_tuples_
  postgres_locks_
}.each do |pg_db_plugin|
  munin_plugin pg_db_plugin do
    plugin "#{pg_db_plugin}#{database}"
    notifies :restart, "service[munin-node]"
  end
end

%w{
  postgres_xlog
  postgres_checkpoints
  postgres_bgwriter
}.each do |pg_plugin|
  munin_plugin pg_plugin do
    notifies :restart, "service[munin-node]"
  end
end
