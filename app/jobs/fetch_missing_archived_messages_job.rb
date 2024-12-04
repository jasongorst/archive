class FetchMissingArchivedMessagesJob < ApplicationJob
  queue_as :default

  OLDEST_DEFAULT = Time.new(2024, 11, 1)

  def perform(oldest: nil)
    oldest = OLDEST_DEFAULT if Rails.env.development? && oldest.nil?

    # ensure emoji are up-to-date
    FetchEmojiJob.perform_now

    connection = Slack::FetchMissingArchivedMessages.new
    channels = connection.fetch_channels

    connection.fetch_messages(channels, oldest: oldest)
  end
end
