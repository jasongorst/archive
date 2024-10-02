require "slack/fetch_private_messages"

class FetchNewPrivateMessagesJob < ApplicationJob
  queue_as :default

  def perform(*only_accounts)
    # ensure emoji are up-to-date
    FetchEmojiJob.perform_now

    bot_users = if only_accounts.present?
                  only_accounts.map { |account| account.bot_user }.compact
                else
                  Team.find_by_name("Firnost & Friends").bot_users.all
                end

    bot_users.each do |bot_user|
      connection = Slack::FetchPrivateMessages.new(bot_user)
      channels = connection.fetch_channels
      connection.fetch_messages(channels)
    end
  end
end
