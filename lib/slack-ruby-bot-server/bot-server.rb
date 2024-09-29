require_relative 'bot-server/service'
require_relative 'bot-server/api'
require_relative 'bot-server/app'

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
end
