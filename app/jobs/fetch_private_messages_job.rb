class FetchPrivateMessagesJob < ApplicationJob
  queue_as :default

  def perform(bot_user, oldest)
    connection = Slack::FetchPrivateMessages.new(bot_user)
    channels = connection.fetch_channels
    connection.fetch_messages(channels, oldest: oldest)
  end
end
