require "slack/emoji"

class FetchEmojiJob < ApplicationJob
  queue_as :default

  def perform
    connection = Slack::Emoji.new

    connection.update_emoji_aliases
    connection.update_custom_emoji

    # EmojiAlias.create_all first calls CustomEmoji.create_all
    EmojiAlias.create_all
  end
end
