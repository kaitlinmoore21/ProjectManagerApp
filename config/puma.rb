# Puma configuration for Rails API backend

# Number of threads per worker
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
threads threads_count, threads_count

# Puma port
port ENV.fetch("PORT") { 3000 }

# Environment
environment ENV.fetch("RAILS_ENV") { "development" }

# Allow Puma to be restarted by `bin/rails restart` command
plugin :tmp_restart

# Optional: specify PID file (usually unnecessary on Render)
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Optional: Uncomment if using multiple workers for concurrency
# workers ENV.fetch("WEB_CONCURRENCY") { 1 }
# preload_app!
