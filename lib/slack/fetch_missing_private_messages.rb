module Slack
  class FetchMissingPrivateMessages < FetchPrivateMessages
    def fetch_messages(slack_channels, oldest: nil)
      @logger.info "Checking for missing messages in #{slack_channels.count} private channels for #{@bot_user.display_name}"

      slack_channels.each do |slack_channel|
        @logger.info "Checking for missing messages in private channel #{slack_channel.id} for #{@bot_user.display_name}"

        private_channel = ::PrivateChannel.find_or_create_by(slack_channel: slack_channel.id) do |c|
          c.channel_created_at = Time.at(slack_channel.created)
          c.name = (slack_channel.name unless slack_channel.is_mpim)
        end

        private_channel.archived = slack_channel.is_archived
        private_channel.save!

        members = @user_client.conversations_members(channel: slack_channel.id).members

        if members.present?
          private_channel.users = members.map do |member|
            ::User.find_or_create_by(slack_user: member) do |user|
              slack_user = Slack::User.new(member)
              user.display_name = slack_user.display_name
              user.is_bot = slack_user.is_bot
              user.deleted = slack_user.deleted
            end
          end
        end

        archive_messages(private_channel, oldest: oldest)
      end
    end

    private

    def archive_messages(private_channel, oldest: nil)
      @user_client.conversations_history(
        channel: private_channel.slack_channel,
        oldest: (format("%.6f", oldest) if oldest),
        inclusive: false,
        request: { timeout: 60 * 60 }
      ) do |response|
        ::PrivateMessage.transaction do
          messages = response.messages
          @logger.info "Checking #{messages.count} private messages from #{private_channel.slack_channel} for #{@bot_user.display_name}"

          messages.each do |m|
            next if private_channel.private_messages.exists?(ts: m.ts.to_d)

            slack_message = Slack::Message.new(m)
            next if slack_message.user.nil?

            private_message = private_channel.private_messages.create!(
              user: slack_message.user,
              text: slack_message.text,
              ts: slack_message.ts,
              verbatim: slack_message.verbatim
            )

            private_message.attachments.create!(slack_message.attachments) if slack_message.attachments
          end

          if messages.count > 0
            @logger.info "checked private channel #{private_channel.slack_channel}: #{messages.first.ts} - #{messages.last.ts}"
          end

          sleep 1
        end
      end
    end
  end
end
