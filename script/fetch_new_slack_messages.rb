#!/usr/bin/env rails runner
require_relative '../lib/slack/slack_new_messages'

begin
  # initialize
  fetch = SlackNewMessages.new

  # fetch fetch channels
  fetch.fetch_slack_channels

  # fetch messages
  fetch.fetch_messages

rescue Slack::Web::Api::Errors::SlackError => e
  warn e.full_message
rescue StandardError
  warn e.full_message
end
