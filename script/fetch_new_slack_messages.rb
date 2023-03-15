#!/usr/bin/env rails runner
require 'slack/slack_new_messages'
require_relative './fetch_slack_emoji'
require_relative './initialize_emoji'

begin
  # initialize
  connection = SlackNewMessages.new

  # ensure that searchd is running
  connection.logger.warn 'Checking searchd status.'

  r, w = IO.pipe
  status = system('rake ts:status', out: w)
  w.close

  unless status
    connection.logger.error 'Unable to check searchd status!'
    connection.logger.error "\n\t#{r.readlines.join("\t")}"
    abort 'Unable to check searchd status before fetching slack messages.'
  end

  if r.read == "The Sphinx daemon searchd is not currently running.\n"
    # start searchd
    connection.logger.warn 'searchd is not running. Starting searchd.'

    r, w = IO.pipe
    status = system('rake ts:start', out: w)
    w.close

    if status
      connection.logger.warn 'searchd started.'
      connection.logger.warn "\n\t#{r.readlines.join("\t")}"
    else
      connection.logger.error 'Error starting searchd!'
      connection.logger.error "\n\t#{r.readlines.join("\t")}"
      abort 'Unable to start searchd before fetching slack messages.'
    end
  else
    connection.logger.warn 'searchd is running.'
  end

  # fetch channels
  channels = connection.fetch_slack_channels

  # in development, filter out all but 'sandbox' channel
  channels.filter! { |sch| 'ooc'.include? sch.name } if Rails.env == 'development'

  # fetch messages
  connection.fetch_slack_messages(channels)

rescue => err
  Rails.logger.fatal("Caught exception in fetch_new_slack_messages.rb; exiting")
  Rails.logger.fatal(err)
end
