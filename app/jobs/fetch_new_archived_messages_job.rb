class FetchNewArchivedMessagesJob < ApplicationJob
  queue_as :default

  def perform
    # ensure emoji are up-to-date
    FetchEmojiJob.perform_now

    connection = Slack::FetchArchivedMessages.new
    channels = connection.fetch_channels

    connection.fetch_messages(channels)
  end
end
