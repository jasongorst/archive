require "mrkdwn/slack_multiline_code_filter"
require "mrkdwn/line_break_filter"
require "mrkdwn/slack_code_filter"
require "mrkdwn/emoji_filter"
require "mrkdwn/slack_mention_filter"
require "mrkdwn/slack_link_filter"
require "mrkdwn/slack_style_filter"
require "mrkdwn/slack_blockquote_filter"

context = {
  :slack_channels => Channel.pluck(:slack_channel, :name).to_h,
  :slack_users => User.pluck(:slack_user, :display_name).to_h
}

Mrkdwn = HTML::Pipeline.new [
                        HTML::Pipeline::PlainTextInputFilter,
                        SlackMultilineCodeFilter,
                        LineBreakFilter,
                        SlackCodeFilter,
                        EmojiFilter,
                        SlackMentionFilter,
                        SlackLinkFilter,
                        SlackStyleFilter,
                        SlackBlockquoteFilter
                      ], context
