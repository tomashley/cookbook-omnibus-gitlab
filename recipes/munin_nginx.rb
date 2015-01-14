%w{
  nginx_memory
  nginx_request
  nginx_status
}.each do |plugin|
  munin_plugin plugin do
    create_file true
  end
end
