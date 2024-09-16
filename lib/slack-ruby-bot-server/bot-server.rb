require_relative 'bot-server/service'
require_relative 'bot-server/api'
require_relative 'bot-server/app'
# require_relative 'bot-server/oauth'

module BotServer
  USER_OAUTH_SCOPE = %w[
    groups:history
    groups:read
    identify
    im:history
    im:read
    mpim:history
    mpim:read
  ].freeze

  REDIRECT_URL = "https://exactly-mint-chamois.ngrok-free.app/oauth".freeze
end
