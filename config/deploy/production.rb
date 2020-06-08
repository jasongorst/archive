# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
server "evilpaws.org", user: "deploy", port: 7822, roles: %w{app db web}, primary: true

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
set :stage, :production
set :rails_env, :production
# set dummy key for rake assets:precompile
set :default_env, { secret_key_base: 'ab8589d3b29720667a0a036ddca612298097f25aa023cfe342fc131291c2be94d132ff97f84a8bd7d3edb1625b53f225ffadbe39e9dcdd43a414f45c8278ab7f' }
