#!/usr/bin/env rails runner
require 'slack/slack_new_messages'
require_relative 'fetch_slack_emoji'
require_relative './initialize_emoji'

begin
  # initialize
  connection = SlackNewMessages.new

  # fetch slack channels
  channels = connection.fetch_slack_channels

  # filter out all but 'sandbox' channel
  channels.filter! { |sch| %w[sandbox].include? sch.name }

  # fetch messages
  connection.fetch_slack_messages(channels)
end
