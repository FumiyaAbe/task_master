# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.
#
# Puma starts a configurable number of processes (workers) and each process
# serves each request in a thread from an internal thread pool.
#
# You can control the number of workers using ENV["WEB_CONCURRENCY"]. You
# should only set this value when you want to run 2 or more workers. The
# default in this app is a single process (0 or 1 worker).
#
# The ideal number of threads per worker depends both on how much time the
# application spends waiting for IO operations and on how much you wish to
# prioritize throughput over latency.
#
# As a rule of thumb, increasing the number of threads will increase how much
# traffic a given process can handle (throughput), but due to CRuby's
# Global VM Lock (GVL) it has diminishing returns and will degrade the
# response time (latency) of the application.
#
# The default here is set to 5 threads as a balanced compromise for many Rails
# apps and to match your previous `-t 5:5` CLI setting.
#
# Any libraries that use a connection pool or another resource pool should
# be configured to provide at least as many connections as the number of
# threads. This includes Active Record's `pool` parameter in `database.yml`.

# === Threads (equivalent to CLI: `-t 5:5`)
max_threads = Integer(ENV.fetch("RAILS_MAX_THREADS", 5))
min_threads = Integer(ENV.fetch("RAILS_MIN_THREADS", max_threads))
threads min_threads, max_threads

# === Port (equivalent to CLI: `-p ${PORT:-3000}`)
# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT", 3000)

# === Environment
# Prefer RAILS_ENV over RACK_ENV for Rails apps. Default to "production" in this config
# so that accidental development boots in production environments are avoided.
environment ENV.fetch("RAILS_ENV", "production")

# === Workers / Processes
# For Render Free instances (0.1 CPU), a single process is typical.
# Increase only if you have enough CPU/memory and a need for concurrency.
workers Integer(ENV.fetch("WEB_CONCURRENCY", 0))

# Preload application code before forking workers to reduce memory usage.
# Only meaningful when workers > 0, but harmless otherwise.
preload_app! if ENV.fetch("WEB_CONCURRENCY", "0").to_i > 0

# Allow Puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Run the Solid Queue supervisor inside Puma for single-server deployments
# (enable only when you set SOLID_QUEUE_IN_PUMA=1)
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# Specify the PID file. Defaults to tmp/pids/server.pid in development.
# In other environments, only set the PID file if requested.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
