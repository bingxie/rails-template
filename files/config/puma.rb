if ENV['RAILS_ENV'] == 'production'
  shared_dir = '/data/www/myapp/shared'
  pidfile "#{shared_dir}/tmp/pids/puma.pid"
  state_path "#{shared_dir}/tmp/pids/puma.state"
  bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
  activate_control_app "unix://#{shared_dir}/tmp/sockets/pumactl.sock"

  stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

  daemonize true
  workers 2
  threads 8, 16
  preload_app!

  on_worker_boot do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.establish_connection
    end
  end

  before_fork do
    ActiveRecord::Base.connection_pool.disconnect!
  end
else
  plugin :tmp_restart
end
