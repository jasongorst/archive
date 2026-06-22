source "https://gem.coop"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3"

# Propshaft asset pipeline
gem "propshaft", "~> 1.3.2"

# Use trilogy as the database for Active Record
gem "trilogy", "~> 2.12.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 7.2.1"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", "~> 1.3.1"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "~> 2.0.23"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "~> 1.3.4"

# # Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails", "~> 1.4.3"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "~> 2.15.1"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.24.6", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.14.0"
gem "ruby-vips", "~> 2.3.0"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", "~> 1.11.1", platforms: %i[ mri windows ], require: "debug/prelude"

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", "~> 1.1.0", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console", "~> 4.3.0"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring", "~> 4.6.0"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", "~> 3.40.0"
end

# Use capistrano for deployment
group :development do
  gem "bcrypt_pbkdf", "~> 1.1.2", require: false
  gem "ed25519", "~> 1.4.0", require: false
  gem "capistrano", "~> 3.20.1", require: false
  gem "capistrano-rails", "~> 1.7.0", require: false
  # gem "capistrano-rbenv", "~> 2.2.0", require: false
  gem "capistrano-passenger", "~> 0.2.1", require: false
end

# Use haml for templates
gem "haml", "~> 7.2.0"
gem "haml-rails", "~> 3.0.0"
gem "html2haml", "~> 2.3.0"

# BigDecimal for nanosecond timestamps
gem "bigdecimal", "~> 4.1.2"

# Slack api client
gem "slack-ruby-client", "~> 3.1.0"

# Pagination
gem "kaminari", "~> 1.2.2"

# Full-text search middleware for sphinx/manticore
gem "thinking-sphinx", github: "jasongorst/thinking-sphinx"
gem "mysql2", "~> 0.5.7"

# Pretty URLs
gem "friendly_id", "~> 5.7.0"

# trestle admin framework
gem "trestle", "~> 0.10.1"

# use clearance for authentication
gem "clearance", "~> 2.12.0"

# check passwords against haveibeenpwned.com
gem "pwned", "~> 2.4.1"

# convert slack mrkdwn to html
gem "html-pipeline-mrkdwn", "~> 0.2.1"

# use postmark for outgoing email
gem "postmark-rails", "~> 0.22.1"

# solid_queue to back ActiveJobs
gem "solid_queue", "~> 1.4.0"

# mission_control-jobs to manage solid_queue job runs
gem "mission_control-jobs", "~> 1.1.0"

# bullet for n+1 checks
gem "bullet", "~> 8.1.3", group: "development"

# also prospite for n+1 checks
gem "prosopite", "~> 2.2.0"

# solid_cache
gem "solid_cache", "~> 1.0.10"

# sqlite3 for solid_cache
gem "sqlite3", "~> 2.9.5"
