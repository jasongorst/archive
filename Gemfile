source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1", ">= 7.1.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails", "~> 3.4"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", "~> 1.3"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "~> 2.0"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "~> 1.3"

# # Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails", "~> 1.4"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "~> 2.11"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.18", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", '~> 1.12'
gem "ruby-vips", "~> 2.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", "~> 1.9", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console", "~> 4.2"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem "rack-mini-profiler", "~> 3.3", require: false
  gem "html2haml", "~> 2.3"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", "~> 3.40"
  gem "webdrivers", "~> 5.3"
end

# Use capistrano for deployment
group :development do
  gem "bcrypt_pbkdf", "~> 1.1", require: false
  gem "ed25519", "~> 1.3", require: false
  gem "capistrano", "~> 3.18", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-passenger", "~> 0.2", require: false
end

# Use haml for templates
gem "haml", "~> 6.3"
gem "haml-rails", "~> 2.1"

# use memcached for caching
gem "dalli", "~> 3.2"

# BigDecimal for nanosecond timestamps
gem "bigdecimal", "~> 3.1"

# Slack api client
gem "slack-ruby-client", '~> 2.3'

# Pagination
gem "kaminari", "~> 1.2"

# Full-text search middleware for sphinx/manticore
gem "thinking-sphinx", '~> 5.5'

# Pretty URLs
gem "friendly_id", '~> 5.5'

# Ruby cron jobs
gem "whenever", '~> 1.0', require: false

# use administrate for model dashboards
gem "administrate", github: "thoughtbot/administrate"

# use clearance for authentication
gem "clearance", "~> 2.6"

# validate passwords for entropy bits
gem "strong_password", "~> 0.0"

# convert slack mrkdwn to html
gem "html-pipeline-mrkdwn", "~> 0.1"

# use postmark for outgoing email
gem "postmark-rails", "~> 0.22"
