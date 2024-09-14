# Load the Rails application.
require_relative "application"

# Load BotServer
require_relative "../lib/slack-ruby-bot-server/app"

# Initialize the Rails application.
Rails.application.initialize!
