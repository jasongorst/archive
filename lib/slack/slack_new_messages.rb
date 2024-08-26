require "slack/slack_client"
require "slack/slack_user"
require "slack/mrkdwn"

class SlackNewMessages
  SLACK_COLORS = {
    "#2eb886" => "good",
    "#daa038" => "warning",
    "#a30200" => "danger"
  }

  attr_accessor :logger

  def initialize
    @sc = SlackClient.new
    @logger = @sc.logger
  end

  def fetch_slack_channels
    # get channel list
    @sc.conversations_list(types: "public_channel", exclude_archived: true).channels
  end

  def fetch_slack_messages(channels)
    channels.each do |sch|
      @logger.info "Archiving slack channel \##{sch.name}"
      # join slack channel
      @sc.conversations_join(channel: sch.id)
      # create or find corresponding archive channel
      channel = Channel.find_or_create_by!(slack_channel: sch.id) do |c|
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
      @logger.info "Saving #{messages.count} messages"

      # process messages
      messages.each do |message|
        # slack will sometimes return the last message regardless of ts
        # check the ts against the last message saved
        next if message.ts.to_d == last_ts

        # save roller messages
        if message.key?(:bot_id) && message.bot_id == User.find_by_display_name("RollerBot 2").slack_user
          save_roller_message(message, channel)
          next
        end
        # ignore other bot messages
        next if message.key?(:subtype) && message.subtype == "bot_message"

        # ignore messages without a user
        next unless message.key? :user

        # save message
        save_message(message, channel)
      end
    end
  end

  def save_message(message, channel)
    # find or create user
    user = User.find_or_create_by!(slack_user: message.user) do |u|
      # fetch slack user info
      slack_user = SlackUser.new(message.user)
      u.display_name = slack_user.display_name
    end

    # convert message text to html
    text = PIPELINE.to_html(message.text)

    # save message
    m = channel.messages.create!(text: text,
                                 verbatim: message.text,
                                 ts: message.ts.to_d,
                                 user_id: user.id)

    # save attachments
    if message.key?(:files)
      message.files.each do |f|
        m.attachments.create!(name: f.name, url: f.url_private)
      end
    end
  end

  def save_roller_message(message, channel)
    rollerbot = User.find_by_display_name("RollerBot 2")

    # parse message attachment (assume only one)
    attachment = message.attachments.first
    color = SLACK_COLORS[attachment.color] || "none"

    block = attachment.blocks.first
    text = PIPELINE.to_html(block.text.text)

    fields = if block.fields.count == 1
               # /coin
               block.fields[0].text.split("\n")
             elsif block.fields.count == 4
               # /dice or /roll (no extra rolls)
                [
                  block.fields[0].text,
                  block.fields[2].text,
                  block.fields[1].text,
                  block.fields[3].text
                ]
             elsif block.fields.count == 7
               # /roll (with extra rolls)
               [
                 block.fields[0].text,
                 block.fields[2].text,
                 block.fields[1].text,
                 block.fields[3].text,
                 block.fields[4].text,
                 block.fields[6].text
               ]
             else
               # ?
             end

    fields = fields.map do |field|
      PIPELINE.to_html(field)
    end

    # save message
    channel.messages.create!(text: render_roller_message_text(color, text, fields),
                             ts: message.ts.to_d,
                             user_id: rollerbot.id)
  end

  def render_roller_message_text(color, text, fields)
    ApplicationController.renderer.render(partial: "roller/message",
                                          locals: { color: color,
                                                    text: text,
                                                    fields: fields })
  end
end
