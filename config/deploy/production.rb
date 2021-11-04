# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
server 'server.evilpaws.org', user: 'deploy', port: 7822, roles: %w{app db web}, primary: true

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
set :stage, :production
set :rails_env, :production
set :default_env, { secret_key_base: `rails secret` } # dummy key to appease rake assets:precompile
set :bundle_jobs, 4
