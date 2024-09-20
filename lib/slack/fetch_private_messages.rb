require "slack/client"
require "slack/user"
require "slack/message"

module Slack
  class FetchPrivateMessages < FetchMessages
    attr_accessor :bot_user, :user_client

    CONVERSATION_TYPES = %w[im mpim private_channel].join(",").freeze

    def initialize(bot_user)
      @bot_user = bot_user
      @user_client = Slack::Client.new(token: bot_user.user_access_token)
      super
    end

    def fetch_channels
      @user_client.conversations_list(types: CONVERSATION_TYPES).channel
    end

    def fetch_messages(slack_channels)
      slack_channels.each do |slack_channel|
        puts "Archiving private channel #{slack_channel.id} for #{@bot_user.display_name}"

        private_channel = PrivateChannel.find_or_create_by(slack_channel: slack_channel.id) do |c|
          c.channel_created_at = Time.at(slack_channel.created)
        end

        members = @user_client.conversations_members(channel: slack_channel.id).members

        private_channel.users = members.map do |member|
          User.find_or_create_by(slack_user: member) do |user|
            slack_user = Slack::User.new(member)
            user.display_name = slack_user.display_name
            user.is_bot = slack_user.is_bot
            user.deleted = slack_user.deleted
          end

          last_ts = private_channel&.private_messages&.last&.ts || 0
          archive_messages(private_channel, last_ts)
        end
      end
    end

    private

    def archive_messages(slack_channel, last_ts)
      @user_client.conversations_history(
        channel: slack_channel.id,
        oldest: last_ts,
        inclusive: false
      ) do |response|

        messages = response.messages
        @logger.info "Archiving #{messages.count} private messages in #{slack_channel.id} for #{@bot_user.display_name}"

        messages.each do |m|
          slack_message = Slack::Message.new(m)

          private_message = private_channel.private_messages.create!(
            user: slack_message.user,
            text: slack_message.text,
            ts: slack_message.ts,
            verbatim: slack_message.verbatim
          )

          private_message.attachments.create!(slack_message.attachments) if slack_message.attachments
        end
      end
    end
  end
end
