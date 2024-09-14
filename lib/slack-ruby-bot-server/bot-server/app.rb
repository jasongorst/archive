require_relative 'activerecord'

using BotServer::DatabaseAdapter

module BotServer
  class App < SlackRubyBotServer::App
  end
end
