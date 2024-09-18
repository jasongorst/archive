require "slack/mrkdwn"
require "slack/slack_message"

stdout_logger = Logger.new(STDOUT, level: Logger::DEBUG)
file_logger = Logger.new("log/#{ENV['RACK_ENV']}.log", level: Logger::INFO)
logger = ActiveSupport::BroadcastLogger.new(stdout_logger, file_logger)

begin
  # ensure that searchd is running
  logger.info "Checking searchd status."

  r, w = IO.pipe
  status = system("rake ts:status", out: w)
  w.close

  unless status
    logger.error "Unable to check searchd status!"
    logger.error "\n\t#{r.readlines.join("\t")}"
    abort "Unable to check searchd status before fetching slack messages."
  end

  if r.read == "The Sphinx daemon searchd is not currently running.\n"
    # start searchd
    logger.info "searchd is not running. Starting searchd."

    r, w = IO.pipe
    status = system("rake ts:start", out: w)
    w.close

    if status
      logger.info "searchd started."
      logger.info "\n\t#{r.readlines.join("\t")}"
    else
      logger.error "Error starting searchd!"
      logger.error "\n\t#{r.readlines.join("\t")}"
      abort "Unable to start searchd before fetching slack messages."
    end
  else
    logger.info "searchd is running."
  end

  bot_user = BotUser.find_by_display_name("rae")
  # Team.find_by_name("Firnost & Friends").bot_users.each do |bot_user|
    client = Slack::Web::Client.new(token: bot_user.user_access_token)

    client.conversations_list(types: "im,mpim,private_channel") do |list_response|
      channels = list_response.channels
      puts "Saving #{channels.count} private channels for #{bot_user.display_name}"

      channels.each do |channel|
        puts "Saving private channel #{channel.id} for #{bot_user.display_name}"

        private_channel = PrivateChannel.find_or_create_by(slack_channel: channel.id) do |c|
          c.channel_created_at = Time.at(channel.created)
        end

        members = client.conversations_members(channel: channel.id).members

        private_channel.users = members.map do |member|
          User.find_or_create_by(slack_user: member) do |user|
            slack_user = SlackUser.new(member)
            user.display_name = slack_user.display_name
            user.is_bot = slack_user.is_bot
            user.deleted = slack_user.deleted
          end
        end

        client.conversations_history(channel: channel.id) do |response|
          messages = response.messages

          puts "Saving #{messages.count} private messages for #{bot_user.display_name}"

          messages.each do |message|
            slack_message = SlackMessage.new(message)

            private_message = private_channel.private_messages.create!(
              user: slack_message.user,
              text: slack_message.text,
              ts: slack_message.ts,
              verbatim: slack_message.verbatim
            )

            private_message.attachments.create!(slack_message.attachments) if slack_message.attachments
          end
        end
      end
    end
  # end

rescue => err
  logger.error("Caught exception in fetch_private_messages.rb; exiting")
  logger.error(err)
end
