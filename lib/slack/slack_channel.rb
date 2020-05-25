require_relative 'slack_client'

class SlackChannel
  attr_reader :name, :channel_id

  def initialize(channel_id)
    @channel_id = channel_id
    # initialize Slack client
    c = SlackClient.new
    # fetch user info
    ch = c.conversations_info(channel: channel_id).channel
    @name = ch.name
  end
end
