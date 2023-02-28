#!/usr/bin/env rails runner
require 'slack/slack_new_messages'
require_relative './fetch_slack_emoji'
require_relative './initialize_emoji'

begin
  # initialize
  connection = SlackNewMessages.new

  # ensure that searchd is running
  r, w = IO.pipe
  status = system('rake ts:status', out: w)
  w.close

  # TODO: check exit status

  unless r.read == "The Sphinx daemon searchd is currently running.\n"
    # start searchd
    connection.logger.warn 'Starting searchd...'
    r, w = IO.pipe
    status = system('rake ts:start', out: w)
    w.close

    connection.logger.warn r.readlines.join

    # TODO: check exit status
  end

  # fetch channels
  channels = connection.fetch_slack_channels

  # in development, filter out all but 'sandbox' channel
  channels.filter! { |sch| 'ooc'.include? sch.name } if Rails.env = 'development'

  # fetch messages
  connection.fetch_slack_messages(channels)
end
