require_relative 'slack_client'
require_relative 'slack_user'
require_relative '../mrkdwn/mrkdwn'

class SlackSandboxMessages
  ROLLER_ID = 'B9NN70B0F'.freeze

  def initialize
    @sc = SlackClient.new
  end

  def slack_channels
    # get channel list
    @slack_channels = @sc.conversations_list(types: 'public_channel',
                                             exclude_archived: true).channels
    # find sandbox channel
    @sandbox = @slack_channels.find { |ch| ch.name == 'sandbox' }
  end

  def slack_messages
    $stderr.print 'Archiving channel sandbox'
    # join slack channel
    @sc.conversations_join(channel: @sandbox.id)
    # create or find corresponding archive channel
    channel = Channel.find_by(slack_channel: @sandbox.id)

    retrieve_and_save_messages(channel)
  end

  private

  def retrieve_and_save_messages(channel)
    # get messages in this channel (in default slack batch size)
    @sc.conversations_history(presence: true,
                              channel: channel.slack_channel) do |response|
      messages = response.messages

      # process messages
      messages.each do |message|
        # save roller messages
        if message.key?(:bot_id) && message.bot_id == ROLLER_ID
          save_roller_message(message, channel)
          $stderr.print '-'
          next
        end
        # ignore other bot messages
        next if message.key?(:subtype) && message.subtype == 'bot_message'
        # ignore messages without a user
        next unless message.key? :user

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

  def save_roller_message(message, channel)
    user = User.find_by(slack_user: ROLLER_ID)

    # parse message attachment (assume only one)
    m = message.attachments.first
    color = m.color
    text = Mrkdwn.convert(m.text)
    fields = m.fields.to_a.map(&:to_h)
    fields.each do |f|
      f['value'] = Mrkdwn.convert(f['value'])
    end

    # messily construct message html
    html = <<~HTML
      <div class="attachment" style="border-left: 4px solid \##{color}; border-radius: 8px;">
        <div class="attachment_text" style="padding-left: 12px;">
          <div>#{text}</div>
    HTML

    fields.each do |f|
      html << "      <div><b>#{f['title']}</b></div>\n"
      html << "      <div>#{f['value']}</div>\n"
    end

    html << "    </div>\n  </div>\n"

    # save message
    channel.messages.create(text: html,
                            ts: message.ts.to_d,
                            user_id: user.id)
  end
end
