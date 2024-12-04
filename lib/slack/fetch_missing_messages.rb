module Slack
  class FetchMissingMessages < FetchMessages
    def fetch_messages(slack_channels, oldest: nil)
      slack_channels.each do |slack_channel|
        @logger.info "Checking for missing messages in channel \##{slack_channel.name}"

        channel = ::Channel.find_or_create_by!(slack_channel: slack_channel.id) do |c|
          c.name = slack_channel.name
        end

        channel.archived = slack_channel.is_archived
        channel.save!

        archive_messages(channel, oldest: oldest)
      end
    end

    private

    def archive_messages(channel, oldest: nil)
      @client.conversations_join(channel: channel.slack_channel) unless channel.archived?

      @client.conversations_history(
        channel: channel.slack_channel,
        oldest: (format("%.6f", oldest) if oldest),
        inclusive: false,
        request: { timeout: 60 * 60 }
      ) do |response|
        ::Message.transaction do
          messages = response.messages
          @logger.info "Checking #{messages.count} messages from \##{channel.name}"

          messages.each do |m|
            next if channel.messages.exists?(ts: m.ts.to_d)

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

          if messages.count > 0
            @logger.info "checked channel #{channel.slack_channel}: #{messages.first.ts} - #{messages.last.ts}"
          end

          sleep 1
        end
      end
    end
  end
end
