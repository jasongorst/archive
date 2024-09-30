class FetchNewPrivateMessagesJob < ApplicationJob
  queue_as :default

  def perform(*only_accounts)
    Team.find_by_name("Firnost & Friends").bot_users.each do |bot_user|
      connection = Slack::FetchPrivateMessages.new(bot_user)
      channels = connection.fetch_channels
      connection.fetch_messages(channels)
    end
  end
end
