workers 2
threads 1,5

bind 'unix://tmp/sockets/backend.sock'
stdout_redirect 'log/puma.stdout.log', 'log/puma.stderr.log', true
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

preload_app!
rackup DefaultRackup

on_worker_boot do
# Here we are establishing the connection after forking worker
# processes
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

before_fork do
# This option works in together with preload_app! setting
# What is does is prevent the master process from holding
# the database connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection_pool.disconnect!
end
