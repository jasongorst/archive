require_relative 'slack_client'
require_relative 'slack_user'
require_relative '../mrkdwn/mrkdwn'

class SlackNewMessages
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
      last_ts = last_message.nil? ? 0 : last_message.ts

      retrieve_and_save_messages(channel, last_ts)
    end
  end

  private

  def retrieve_and_save_messages(channel, last_ts)
    # get new messages in this channel (in default slack batch size)
    @sc.conversations_history(presence: true,
                              channel: channel.slack_channel,
                              oldest: last_ts,
                              inclusive: false) do |response|
      messages = response.messages

      # process messages
      messages.each do |message|
        # ignore bot messages
        next if message.key?(:subtype) && message.subtype == 'bot_message'
        # ignore messages without a user
        next unless message.key? :user
        # slack will sometimes return the last message regardless of ts
        # check the ts against the last message saved
        next if message.ts.to_d == last_ts

        # save message
        save_message(message, channel)
        $stderr.print '.'
      end
    end
    $stderr.print "\n"
  end

  def save_message(message, channel)
    # find or create user
    user = User.find_or_create_by(slack_user: message.user) do |u|
      # fetch slack user info
      slack_user = SlackUser.new(message.user)
      u.display_name = slack_user.display_name
    end

    # convert message text to html
    text = Mrkdwn.convert(message.text)

    # save message
    m = channel.messages.create(text: text,
                                ts: message.ts.to_d,
                                user_id: user.id)

    return unless message.key? :files

    # save attachments
    message.files.each do |f|
      m.attachments.create(name: f.name,
                           url: f.url_private)
    end
  end
end
