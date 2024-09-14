module BotServer
  module DatabaseAdapter
    refine SlackRubyBotServer::DatabaseAdapter do
      def self.init!
      end
    end
  end
end
