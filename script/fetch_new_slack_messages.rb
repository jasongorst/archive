#!/usr/bin/env rails runner
require 'slack/slack_new_messages'
require_relative './fetch_slack_emoji'
require_relative './initialize_emoji'

begin
  # ensure that manticore is running
  system('rake ts:start')

  # initialize
  connection = SlackNewMessages.new

  # fetch channels
  channels = connection.fetch_slack_channels

  # fetch messages
  connection.fetch_slack_messages(channels)
end
