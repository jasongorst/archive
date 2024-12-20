require "slack/client"
require "slack/message"

module Slack
  class FetchOldMessages
    attr_accessor :logger, :client

    def initialize
      @logger = Rails.logger
      @client = Slack::Client.new
    end

    def fetch_channels
      channels = []

      @client.conversations_list(types: "public_channel", exclude_archived: true) do |response|
        channels.concat(response.channels)
      end

      channels
    end

    def fetch_messages(slack_channels)
      slack_channels.each do |slack_channel|
        @logger.info "Archiving channel \##{slack_channel.name}"

        channel = ::Channel.find_or_create_by!(slack_channel: slack_channel.id) do |c|
          c.name = slack_channel.name
        end

        channel.archived = slack_channel.is_archived
        channel.save!

        oldest_ts = channel.messages.minimum(:ts)
        archive_messages(channel, oldest_ts)
      end
    end

    private

    def archive_messages(channel, oldest_ts)
      @client.conversations_join(channel: channel.slack_channel) unless channel.archived?

      @client.conversations_history(
        channel: channel.slack_channel,
        latest: (format("%.6f", oldest_ts) if oldest_ts),
        inclusive: false
      ) do |response|
        ::Message.transaction do
          messages = response.messages
          @logger.info "Archiving #{messages.count} messages from \##{channel.name}"

          messages.each do |m|
            slack_message = Slack::Message.new(m)
            next if slack_message.user.nil?

            message = channel.messages.create!(
              user: slack_message.user,
              text: slack_message.text,
              ts: slack_message.ts,
              verbatim: slack_message.verbatim
            )

            message.attachments.create!(slack_message.attachments) if slack_message.attachments
          end
        end
      end
    end
  end
end
