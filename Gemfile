source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0"

# Propshaft asset pipeline
gem "propshaft", "~> 1.2"

# Use trilogy as the database for Active Record
gem "trilogy", "~> 2.9"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.6"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", "~> 1.3"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "~> 2.0"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "~> 1.3"

# # Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails", "~> 1.4"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "~> 2.13"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.18", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.14"
gem "ruby-vips", "~> 2.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", "~> 1.11", platforms: %i[ mri windows ], require: "debug/prelude"

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", "~> 1.1", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console", "~> 4.2"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring", "~> 4.3"

  # Speed up propshaft checking for asset updates
  gem "listen", "~> 3.9"

  # bullet for n+1 checks
  gem "bullet", "~> 8.0"

  # also prospite for n+1 checks
  gem "prosopite", "~> 2.1"

  # Use capistrano for deployment
  gem "bcrypt_pbkdf", "~> 1.1", require: false
  gem "ed25519", "~> 1.4", require: false
  gem "capistrano", "~> 3.19", require: false
  gem "capistrano-rails", "~> 1.7", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-passenger", "~> 0.2", require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", "~> 3.40"
end

# Use haml for templates
gem "haml", "~> 6.3"
gem "haml-rails", "~> 2.1"
gem "html2haml", "~> 2.3"

# BigDecimal for nanosecond timestamps
gem "bigdecimal", "~> 3.2"

# Slack api client
gem "slack-ruby-client", "~> 2.7"

# Pagination
gem "kaminari", "~> 1.2"

# Full-text search middleware for sphinx/manticore
gem "thinking-sphinx", github: "jasongorst/thinking-sphinx"
gem "mysql2", "~> 0.5"

# Pretty URLs
gem "friendly_id", "~> 5.5"

# use clearance for authentication
gem "clearance", "~> 2.10"

# check passwords against haveibeenpwned.com
gem "pwned", "~> 2.4"

# convert slack mrkdwn to html
gem "html-pipeline-mrkdwn", "~> 0.2"

# use postmark for outgoing email
gem "postmark-rails", "~> 0.22"

# solid_queue to back ActiveJobs
gem "solid_queue", "~> 1.2"

# mission_control-jobs to manage solid_queue job runs
gem "mission_control-jobs", "~> 1.1"

# solid_cache
gem "solid_cache", "~> 1.0"

# sqlite3 for solid_cache
gem "sqlite3", "~> 2.7"

# trestle admin framework
gem "trestle", "~> 0.10"
