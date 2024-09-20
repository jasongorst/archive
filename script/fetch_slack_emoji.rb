require "slack/emoji"

begin
  connection = Slack::Emoji.new

  connection.update_emoji_aliases
  connection.update_custom_emoji
end
