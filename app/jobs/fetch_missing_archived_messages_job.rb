class FetchMissingArchivedMessagesJob < ApplicationJob
  queue_as :default

  def perform
    # ensure emoji are up-to-date
    FetchEmojiJob.perform_now

    connection = Slack::FetchMissingArchivedMessages.new
    channels = connection.fetch_channels

    connection.fetch_messages(channels)
  end
end
