require "slack/fetch_messages"

class FetchNewMessagesJob < ApplicationJob
  queue_as :default

  def perform(*only_channels)
    # first ensure emoji are up-to-date
    FetchEmojiJob.perform_now

    connection = Slack::FetchMessages.new
    channels = connection.fetch_channels

    # in development, default to only "ooc" channel
    only_channels = ["ooc"] if Rails.env.development?

    # filter channels (by name)
    channels.filter! { |channel| only_channels.include? channel.name } if only_channels.present?

    connection.fetch_messages(channels)
  end
end
