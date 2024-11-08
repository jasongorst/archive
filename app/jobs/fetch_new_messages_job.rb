class FetchNewMessagesJob < ApplicationJob
  queue_as :default

  OLDEST_DEFAULT = Time.new(2024, 10, 1)

  def perform(only_channels: nil, oldest: nil)
    if Rails.env.development?
      only_channels = [ "ooc" ] unless only_channels
      oldest = OLDEST_DEFAULT unless oldest
    end

    # ensure emoji are up-to-date
    FetchEmojiJob.perform_now

    connection = Slack::FetchMessages.new
    channels = connection.fetch_channels

    # in development, default to only "ooc" channel
    only_channels = [ "ooc" ] if Rails.env.development? && only_channels.nil?

    # filter channels (by name)
    channels.filter! { |channel| only_channels.include? channel.name } if only_channels

    connection.fetch_messages(channels, oldest: oldest)
  end
end
