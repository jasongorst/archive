require_relative 'bot-server'

Dir[File.expand_path('initializers', __dir__) + '/*.rb'].sort.each do |file|
  require file
end

# copy slack secrets from credentials to ENV
# %w[slack_client_id slack_client_secret slack_signing_secret slack_verification_token].each do |key|
#   ENV[key.upcase] = Rails.application.credentials[key]
# end

# remove slack-ruby-bot-server's Team in favor of Rails model
Object.send(:remove_const, :Team)
