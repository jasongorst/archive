require "slack/mrkdwn"
require "slack/bot"
require "slack/user"

module Slack
  class Message
    ROLLER_V2_DISPLAY_NAME = "RollerBot 2".freeze
    ROLLER_DISPLAY_NAME = "Roller".freeze

    # noinspection RubyStringKeysInHashInspection
    ROLLER_COLORS = {
      "2eb886" => "good",
      "#2eb886" => "good",
      "daa038" => "warning",
      "#daa038" => "warning",
      "a30200" => "danger",
      "#a30200" => "danger"
    }.freeze

    EARLIEST_ROLLER_MESSAGE_TS = Date.parse("2018-03-14").to_time.to_i

    attr_reader :message,
                :user,
                :text,
                :verbatim,
                :ts,
                :attachments

    def initialize(message)
      @message = message

      if @message.subtype == "bot_message" && @message.bot_id.blank? && @message&.user != "USLACKBOT"
        Rails.logger.warn "Bot message without bot_id: #{message}"
      elsif @message.user.blank?
        Rails.logger.warn "Message without user: #{message}"
      elsif @message.subtype == "bot_message" &&
            @message.bot_id == ::User.find_by_display_name(ROLLER_V2_DISPLAY_NAME).slack_user
        parse_roller_v2_message!
      elsif @message.subtype == "bot_message" &&
            @message.bot_id == ::User.find_by_display_name(ROLLER_DISPLAY_NAME).slack_user &&
            @message.ts.to_d > EARLIEST_ROLLER_MESSAGE_TS
        parse_roller_message!
      else
        parse_message!
      end

      @verbatim = @message.to_json
      @ts = @message.ts.to_d
    end

    private

    def parse_message!
      @user = if @message.subtype == "bot_message" && @message&.user == "USLACKBOT"
                ::User.find_or_create_by!(slack_user: "USLACKBOT") do |u|
                  u.display_name = "Slackbot"
                  u.is_bot = true
                  u.deleted = false
                end
              elsif @message.subtype == "bot_message"
                ::User.find_or_create_by!(slack_user: @message.bot_id) do |u|
                  bot = Slack::Bot.new(@message.bot_id)
                  u.display_name = bot.display_name
                  u.is_bot = bot.is_bot
                  u.deleted = bot.deleted
                end
              else
                ::User.find_or_create_by!(slack_user: @message.user) do |u|
                  user = Slack::User.new(@message.user)
                  u.display_name = user.display_name
                  u.is_bot = user.is_bot
                  u.deleted = user.deleted
                end
              end

      @text = Slack::Mrkdwn.to_html(@message.text)

      if @message.has_key?(:files)
        @attachments = @message.files
                               .reject { |file| file.url_private.nil? }
                               .map { |file| { name: file.name || "file", url: file.url_private } }
      end
    end

    def parse_roller_v2_message!
      @user = ::User.find_by_display_name(ROLLER_V2_DISPLAY_NAME)

      # parse message attachment (assume only one)
      attachment = @message.attachments.first
      color = ROLLER_COLORS[attachment.color] || "none"

      block = attachment.blocks.first
      text = Slack::Mrkdwn.to_html(block.text.text)

      fields = case block.fields.count
      when 1
                 # /coin
                 block.fields[0].text.split("\n")
      when 4
                 # /dice or /roll (no extra rolls)
                 [
                   block.fields[0].text,
                   block.fields[2].text,
                   block.fields[1].text,
                   block.fields[3].text
                 ]
      when 7
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
        Slack::Mrkdwn.to_html(field)
      end

      @text = render_roller_v2_message_text(color, text, fields)
    end

    def parse_roller_message!
      @user = ::User.find_by_display_name(ROLLER_DISPLAY_NAME)

      # parse message attachment (assume only one)
      m = @message.attachments.first
      color = ROLLER_COLORS[m.color]
      text = Slack::Mrkdwn.to_html(m.text)

      fields = m.fields.each do |f|
        f["value"] = Slack::Mrkdwn.to_html(f["value"])
      end

      @text = render_roller_message_text(color, text, fields)
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
end
