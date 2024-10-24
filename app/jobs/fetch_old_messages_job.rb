class FetchOldMessagesJob < ApplicationJob
  queue_as :default

  def perform(*only_channels)
    # ensure emoji are up-to-date
    FetchEmojiJob.perform_now

    connection = Slack::FetchOldMessages.new
    channels = connection.fetch_channels

    # in development, default to only "ooc" channel
    only_channels = [ "ooc" ] if Rails.env.development? && only_channels.blank?

    # filter channels (by name)
    channels.filter! { |channel| only_channels.include? channel.name } if only_channels.present?

    connection.fetch_messages(channels)
  end
end
