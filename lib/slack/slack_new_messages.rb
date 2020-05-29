require_relative 'slack_client'
require_relative 'slack_user'
require_relative '../mrkdwn/line_break_filter'

class SlackNewMessages
  attr_accessor :sc, :channels

  def initialize
    @sc = SlackClient.new
  end

  def fetch_slack_channels
    # get channel list
    @channels = @sc.conversations_list(types: 'public_channel',
                                       exclude_archived: true).channels
  end

  def fetch_messages
    @channels.each do |ch|
      warn "Archiving slack channel \##{ch.name}"
      # join slack channel
      @sc.conversations_join(channel: ch.id)
      # create or find corresponding archive channel
      channel = Channel.find_or_create_by(slack_channel: ch.id) do |c|
        c.name = ch.name
      end

      # find ts of last message in archive channel
      last_message = channel.messages.last
      ts = last_message.nil? ? 0 : last_message.ts

      fetch_and_save_messages(channel, ts)
    end
  end

  private

  def fetch_and_save_messages(channel, ts)
    # get new messages in this channel
    @sc.conversations_history(presence: true,
                              channel: channel.slack_channel,
                              oldest: ts,
                              inclusive: false) do |response|
      messages = response.messages

      # save messages
      messages.each do |message|
        # ignore bot messages
        next if message.key?(:subtype) && message.subtype == 'bot_message'
        # ignore messages without a user
        next unless message.key? :user
        # ignore messages without text
        next unless message.key? :text
        # ignore messages with empty text
        next if message.text.empty?

        # find or create archive user
        user = User.find_or_create_by(slack_user: message.user) do |u|
          # fetch slack user info
          slack_user = SlackUser.new(message.user)
          u.display_name = slack_user.display_name
        end

        # filter message text
        text = LineBreakFilter.convert(message.text)

        # save message
        channel.messages.create(text: text,
                                ts: message.ts.to_d,
                                user_id: user.id)
      end
    end
  end
end
