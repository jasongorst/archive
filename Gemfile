source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.4"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.4", "< 7.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails", "~> 3.5.2"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5.6"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4.3"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", "~> 1.3.1"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "~> 2.0.10"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "~> 1.3.4"

# # Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails", "~> 1.4.1"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "~> 2.13.0"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.18.4", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", '~> 1.13.0'
gem "ruby-vips", "~> 2.2.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", "~> 1.9.2", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console", "~> 4.2.1"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring", "~> 4.2.1"

  gem "rack-mini-profiler", "~> 3.3.1", require: false
  gem "html2haml", "~> 2.3.0"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", "~> 3.40.0"
  gem "webdrivers", "~> 5.3.1"
end

# Use capistrano for deployment
group :development do
  gem "bcrypt_pbkdf", "~> 1.1.1", require: false
  gem "ed25519", "~> 1.3.0", require: false
  gem "capistrano", "~> 3.19.1", require: false
  gem "capistrano-rails", "~> 1.6.3", require: false
  gem "capistrano-rbenv", "~> 2.2.0", require: false
  gem "capistrano-passenger", "~> 0.2.1", require: false
end

# Use haml for templates
gem "haml", "~> 6.3.0"
gem "haml-rails", "~> 2.1.0"

# use memcached for caching
gem "dalli", "~> 3.2.8"

# BigDecimal for nanosecond timestamps
gem "bigdecimal", "~> 3.1.8"

# Slack api client
gem "slack-ruby-client", '~> 2.4.0'

# Pagination
gem "kaminari", "~> 1.2.2"

# Full-text search middleware for sphinx/manticore
gem "thinking-sphinx", github: "jasongorst/thinking-sphinx"

# Pretty URLs
gem "friendly_id", '~> 5.5.1'

# use administrate for model dashboards
gem "administrate", github: "thoughtbot/administrate"

# use clearance for authentication
gem "clearance", "~> 2.8.0"

# check passwords against haveibeenpwned.com
gem "pwned", "~> 2.4.1"

# convert slack mrkdwn to html
gem "html-pipeline-mrkdwn", "~> 0.1.8"

# use postmark for outgoing email
gem "postmark-rails", "~> 0.22.1"

# slack-ruby-bot-server-events
gem "slack-ruby-bot-server", "~> 2.1.1"
gem "slack-ruby-bot-server-events", "~> 0.3.2"
gem "rack", "~> 2.2.9", "< 3.0"
# gem "otr-activerecord", "~> 2.2.0"
gem "pagy_cursor", "~> 0.6.1"

# solid_queue to back ActiveJobs
gem "solid_queue", "~> 1.0.0"
