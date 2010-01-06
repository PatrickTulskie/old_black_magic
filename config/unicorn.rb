# unicorn -c /apps/sample_app/config/unicorn.rb -d -w

# PID file for the Unicorn master
pid '/apps/sample_app/tmp/pids/unicorn.pid'

# This is where the application lives
working_directory "/apps/sample_app"

# 1 Unicorn master, 16 Unicorn workers.  The current server only has 4 cores.  Running 4 workers per core may or may not help us.
worker_processes 16

# Preload the application so forking is quicker
preload_app true

# If we have REE then we can do copy_on_write with our forks
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

# Restart any workers that haven't responded in 30 seconds.  Important since we only have 16 workers and need to handle a lot of requests.
timeout 30

# Listen on a Unix data socket
listen '/apps/sample_app/tmp/sockets/unicorn.sock', :backlog => 2048

# This happens in the master before we fork off the workers.  More needs to be done here.
before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.
 
  old_pid = '/apps/sample_app/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
 
# This happens once the worker has been forked.
after_fork do |server, worker|
  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection 
  ActiveRecord::Base.connection.reconnect!
end