worker_processes 5

timeout 15
listen "unix:tmp/sockets/unicorn.sock", :backlog => 64
pid "tmp/pids/unicorn.pid"
stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

preload_app true

before_fork do |server, worker|
# This option works in together with preload_app true setting
# What is does is prevent the master process from holding
# the database connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
# Here we are establishing the connection after forking worker
# processes
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
