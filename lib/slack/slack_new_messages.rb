require_relative 'slack_client'
require_relative 'slack_user'
require_relative '../mrkdwn/mrkdwn'

class SlackNewMessages
  attr_accessor :sc, :slack_channels

  def initialize
    @sc = SlackClient.new
  end

  def slack_channels
    # get channel list
    @slack_channels = @sc.conversations_list(types: 'public_channel',
                                             exclude_archived: true).channels
  end

  def slack_messages
    @slack_channels.each do |sch|
      $stderr.print "Archiving slack channel \##{sch.name}"
      # join slack channel
      @sc.conversations_join(channel: sch.id)
      # create or find corresponding archive channel
      channel = Channel.find_or_create_by(slack_channel: sch.id) do |c|
        c.name = sch.name
      end

      # find ts of last message in archive channel
      last_message = channel.messages&.last
      ts = last_message.nil? ? 0 : last_message.ts

      retrieve_and_save_messages(channel, ts)
    end
  end

  private

  def retrieve_and_save_messages(channel, ts)
    # get new messages in this channel (in default slack batch size)
    @sc.conversations_history(presence: true,
                              channel: channel.slack_channel,
                              oldest: ts,
                              inclusive: false) do |response|
      messages = response.messages

      # slack will sometimes return duplicates of the last message
      # check the ts against the last message saved (if any)
      last_ts = channel.messages&.last&.ts

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
        # ignore duplicate messages
        next if message.ts.to_d == last_ts

        # find or create user
        user = User.find_or_create_by(slack_user: message.user) do |u|
          # fetch slack user info
          slack_user = SlackUser.new(message.user)
          u.display_name = slack_user.display_name
        end

        # filter message text
        text = Mrkdwn.convert(message.text)

        # save message
        channel.messages.create(text: text,
                                ts: message.ts.to_d,
                                user_id: user.id)
        $stderr.print '.'
      end
    end
    $stderr.print "\n"
  end
end
