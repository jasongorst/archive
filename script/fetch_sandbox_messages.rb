#!/usr/bin/env rails runner
require_relative '../lib/slack/slack_sandbox_messages'

begin
  # initialize
  fetch = SlackSandboxMessages.new

  # fetch fetch channels
  fetch.slack_channels

  # fetch messages
  fetch.slack_messages
end
