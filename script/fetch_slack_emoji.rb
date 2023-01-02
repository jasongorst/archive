#!/usr/bin/env rails runner
require 'slack/slack_emoji'

connection = SlackEmoji.new

connection.update_emoji_aliases
connection.update_custom_emoji
