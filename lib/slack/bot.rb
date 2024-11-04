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
        @display_name = if bot&.name.present?
                          bot.name
                        else
                          "Unnamed Bot <#{@bot_id}>"
                        end

        @deleted = bot.deleted || true
      end
    end
  end
end
