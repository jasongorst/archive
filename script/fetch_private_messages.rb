require "slack/mrkdwn"
require "slack/slack_message"

bot_user = BotUser.find_by_display_name("rae")

client = Slack::Web::Client.new(token: bot_user.user_access_token)

client.conversations_list(types: "im,mpim,private_channel") do |list_response|
  channels = list_response.channels
  puts "Saving #{channels.count} private channels"

  channels.each do |channel|
    puts "Saving private channel #{channel.id}"

    private_channel = PrivateChannel.find_or_create_by(slack_channel: channel.id) do |c|
      c.channel_created_at = Time.at(channel.created)
    end

    members = client.conversations_members(channel: channel.id).members

    private_channel.users = members.map do |member|
      User.find_or_create_by(slack_user: member) do |user|
        slack_user = SlackUser.new(member)
        user.display_name = slack_user.display_name
      end
    end

    client.conversations_history(channel: channel.id) do |response|
      messages = response.messages

      puts "Saving #{messages.count} private messages"

      messages.each do |message|
        slack_message = SlackMessage.new(message)

        private_channel.private_messages.create!(
          user: slack_message.user,
          text: slack_message.text,
          ts: slack_message.ts,
          verbatim: slack_message.verbatim
        )
      end
    end
  end
end
