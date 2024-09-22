require "slack/fetch_messages"
require_relative "./fetch_slack_emoji"
require_relative "./initialize_emoji"

# begin
  # ensure that searchd is running
  Rails.logger.info "Checking searchd status."

  r, w = IO.pipe
  status = system("rake ts:status", out: w)
  w.close

  unless status
    Rails.logger.error "Unable to check searchd status!"
    Rails.logger.error "\n\t#{r.readlines.join("\t")}"
    abort "Unable to check searchd status before fetching slack messages."
  end

  if r.read == "The Sphinx daemon searchd is not currently running.\n"
    # start searchd
    Rails.logger.info "searchd is not running. Starting searchd."

    r, w = IO.pipe
    status = system("rake ts:start", out: w)
    w.close

    if status
      Rails.logger.info "searchd started."
      Rails.logger.info "\n\t#{r.readlines.join("\t")}"
    else
      Rails.logger.error "Error starting searchd!"
      Rails.logger.error "\n\t#{r.readlines.join("\t")}"
      abort "Unable to start searchd before fetching slack messages."
    end
  else
    Rails.logger.info "searchd is running."
  end

  connection = Slack::FetchMessages.new
  channels = connection.fetch_channels

  # in development, filter out all but "ooc" channel
  channels.filter! { |channel| "ooc".include? channel.name } if Rails.env.development?

  connection.fetch_messages(channels)

# rescue => err
#   Rails.logger.error("Caught exception in script/fetch_new_messages.rb; exiting")
#   Rails.logger.error(err)
# end
