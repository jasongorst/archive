# frozen_string_literal: true

context = {
  emoji_image_tag: lambda { |emoji|
    ActionController::Base.helpers.image_tag(emoji.image_filename,
                                                   alt: ":#{emoji.name}:",
                                                   size: "16",
                                                   class: "emoji")},
  slack_channels: Channel.pluck(:slack_channel, :name).to_h,
  slack_users: User.pluck(:slack_user, :display_name).to_h
}

PIPELINE = HTML::Pipeline.new [
                        HTML::Pipeline::PlainTextInputFilter,
                        HTML::Pipeline::Mrkdwn
                      ], context
