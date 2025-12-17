source "https://rubygems.org"

ruby "3.2.4"

# Core Rails
gem "rails", "~> 8.1.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"


# Auth & Security
gem "bcrypt", "~> 3.1.7"
gem "jwt", "~> 2.8"


gem "devise"


# Rails 8 Defaults
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 1.2"


# API / CORS / JSON
gem "rack-cors"
gem "active_model_serializers", "~> 0.10.0"
gem "pagy"


# Platform Compatibility
gem "tzinfo-data", platforms: %i[windows jruby]


# Development & Test
group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false

  # RSpec
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails"

  # specs to work
  gem "shoulda-matchers", "~> 5.0"
end


# Test  
group :test do
  gem "simplecov", require: false
end



