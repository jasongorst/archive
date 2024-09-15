require "slack/mrkdwn"
require "slack/slack_client"
require "slack/slack_bot"
require "slack/slack_user"

class SlackMessage
  ROLLER_V2_DISPLAY_NAME = "RollerBot 2".freeze
  ROLLER_DISPLAY_NAME = "Roller".freeze

  ROLLER_V2_COLORS = {
    "#2eb886" => "good",
    "#daa038" => "warning",
    "#a30200" => "danger"
  }.freeze

  ROLLER_COLORS = {
    "2eb886" => "good",
    "daa038" => "warning",
    "a30200" => "danger"
  }.freeze

  attr_reader :message,
              :user,
              :text,
              :verbatim,
              :ts,
              :attachments

  def initialize(message)
    @message = message

    if @message.has_key?(:subtype) && @message.subtype == "bot_message" &&
      @message.bot_id == User.find_by_display_name(ROLLER_V2_DISPLAY_NAME).slack_user
      parse_roller_v2_message!
    elsif @message.has_key?(:subtype) && @message.subtype == "bot_message" &&
      @message.bot_id == User.find_by_display_name(ROLLER_DISPLAY_NAME).slack_user
      parse_roller_message!
    else
      parse_message!
    end
  end

  private

  def parse_message!
    @user = if @message.has_key?(:subtype) && @message.subtype == "bot_message"
              User.find_or_create_by!(slack_user: @message.bot_id) do |u|
                bot = SlackBot.new(@message.bot_id)
                u.display_name = bot.display_name
              end
            else
              User.find_or_create_by!(slack_user: @message.user) do |u|
                user = SlackUser.new(@message.user)
                u.display_name = user.display_name
              end
            end

    @text = PIPELINE.to_html(@message.text)
    @verbatim = @message.text
    @ts = @message.ts.to_d

    if @message.has_key?(:files)
      @attachments = @message.files.map do |file|
        { name: file.name, url: file.url_private }
      end
    end
  end

  def parse_roller_v2_message!
    @user = User.find_by_display_name(ROLLER_V2_DISPLAY_NAME)

    # parse message attachment (assume only one)
    attachment = @message.attachments.first
    color = ROLLER_V2_COLORS[attachment.color] || "none"

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

    @text = render_roller_v2_message_text(color, text, fields)
    @ts = @message.ts.to_d
  end

  def parse_roller_message!
    @user = User.find_by_display_name(ROLLER_DISPLAY_NAME)

    # parse message attachment (assume only one)
    m = @message.attachments.first
    color = ROLLER_COLORS[m.color]
    text = PIPELINE.to_html(m.text)
    fields = m.fields.each do |f|
      f["value"] = PIPELINE.to_html(f["value"])
    end

    @text = render_roller_message_text(color, text, fields)
    @ts = @message.ts.to_d
  end

  def render_roller_v2_message_text(color, text, fields)
    ApplicationController.renderer.render(partial: "roller_v2/message",
                                          locals: { color: color,
                                                    text: text,
                                                    fields: fields })
  end

  def render_roller_message_text(color, text, fields)
    ApplicationController.renderer.render(partial: "roller/message",
                                          locals: { color: color,
                                                    text: text,
                                                    fields: fields })
  end

  def first_present_of(*args)
    args.select { |arg| arg.present? }.first
  end
end
