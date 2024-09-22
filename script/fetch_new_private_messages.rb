require "slack/fetch_private_messages"
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

  bot_users = if Rails.env.development?
                [BotUser.find_by_display_name("rae")]
              else
                Team.find_by_name("Firnost & Friends").bot_users
              end

  bot_users.each do |bot_user|
    connection = Slack::FetchPrivateMessages.new(bot_user)
    channels = connection.fetch_channels
    connection.fetch_messages(channels)
  end

# rescue => err
#   Rails.logger.error("Caught exception in script/fetch_new_private_messages.rb; exiting")
#   Rails.logger.error(err)
# end
