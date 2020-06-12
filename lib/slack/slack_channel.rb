require_relative 'slack_client'

class SlackChannel
  attr_reader :name, :channel_id

  def initialize(channel_id)
    @channel_id = channel_id
    # initialize Slack client
    sc = SlackClient.new
    # fetch channel info
    c = sc.conversations_info(channel: channel_id).channel
    @name = c.name
  end
end
