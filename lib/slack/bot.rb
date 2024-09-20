require "slack/client"

module Slack
  class Bot
    attr_reader :bot_id, :display_name, :is_bot, :deleted

    def initialize(bot_id)
      @bot_id = bot_id
      @is_bot = true

      begin
        sc = Slack::Client.new
        bot = sc.bots_info(bot: @bot_id).bot
      rescue Slack::Web::Api::Errors::BotNotFound
        @display_name = "Unknown Bot <#{@bot_id}>"
        @deleted = true
      else
        @display_name = bot.name
        @deleted = bot.deleted
      end
    end
  end
end
