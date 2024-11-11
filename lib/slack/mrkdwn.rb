require "html/pipeline"
require "html/pipeline/plain_text_input_filter"
require "html/pipeline/mrkdwn"

module Slack
  class Mrkdwn
    # slack text is already html-escaped, so skip PlainTextInputFilter
    #   and just wrap text in a div tag
    def self.to_html(text)
      pipeline = HTML::Pipeline.new(
        [ HTML::Pipeline::Mrkdwn ],
        {
          emoji_image_tag: ->(emoji) {
            ::CustomEmoji
              .find_by_name(emoji.name)
              .emoji_image_tag(alt: "#{emoji.name}")
          },
          large_emoji_image_tag: ->(emoji) {
            ::CustomEmoji
              .find_by_name(emoji.name)
              .large_emoji_image_tag(alt: "#{emoji.name}")
          },
          large_emoji_class: "emoji-lg",
          slack_channels: ::Channel.pluck(:slack_channel, :name).to_h,
          slack_users: ::User.pluck(:slack_user, :display_name).to_h
        }
      )

      pipeline.to_html("<div>#{text}</div>")
    end
  end
end
