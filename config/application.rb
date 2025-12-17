require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProjectManagerBackend
  class Application < Rails::Application
    config.load_defaults 8.1

    # Only loads a smaller set of middleware suitable for API-only apps
    config.api_only = true

    # Autoload lib/ folder for development
    config.autoload_paths << Rails.root.join('lib')

    # Eager load lib/ folder in production
    config.eager_load_paths << Rails.root.join('lib')

    # --- Quick patch to define missing base classes ---
    QueueBase ||= Class.new
    CacheBase ||= Class.new
    CableBase ||= Class.new
  end
end
