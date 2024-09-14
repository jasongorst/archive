require "slack/slack_client"

class SlackBot
  attr_reader :bot_id, :display_name

  def initialize(bot_id)
    @bot_id = bot_id

    begin
      sc = SlackClient.new
      bot = sc.bots_info(bot: @bot_id).bot
    rescue Slack::Web::Api::Errors::BotNotFound
      @display_name = "Unknown Bot <#{@bot_id}>"
    else
      @display_name = bot.name
    end
  end
end
