require "html/pipeline"
require "html/pipeline/plain_text_input_filter"
require "html/pipeline/mrkdwn"

module Slack
  class Mrkdwn
    CONTEXT = {
      emoji_image_tag: ->(emoji) {
        ActionController::Base.helpers.image_tag(emoji.image_filename,
                                                 alt: "#{emoji.name}",
                                                 class: "emoji",
                                                 size: "16") },
      slack_channels: ::Channel.pluck(:slack_channel, :name).to_h,
      slack_users: ::User.pluck(:slack_user, :display_name).to_h
    }

    PIPELINE = HTML::Pipeline.new [ HTML::Pipeline::PlainTextInputFilter,
                                   HTML::Pipeline::Mrkdwn ], CONTEXT

    def self.to_html(text)
      PIPELINE.to_html(text)
    end
  end
end
