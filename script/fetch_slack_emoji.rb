#!/usr/bin/env rails runner
require 'slack/slack_emoji'

begin
  connection = SlackEmoji.new

  connection.update_emoji_aliases
  connection.update_custom_emoji
end

