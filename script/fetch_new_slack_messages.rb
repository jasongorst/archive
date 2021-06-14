#!/usr/bin/env rails runner
require 'slack/slack_new_messages'

begin
  # initialize
  fetch = SlackNewMessages.new

  # fetch fetch channels
  fetch.slack_channels

  # fetch messages
  fetch.slack_messages
end
