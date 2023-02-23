require 'slack-ruby-client'

class SlackClient < Slack::Web::Client
  def initialize
    # authenticate with Slack
    Slack.configure do |config|
      config.token = Rails.application.credentials.slack_api_token
      config.logger = ::Logger.new(STDOUT)
      config.logger.level = Logger::WARN
    end

    # set up new Web API client
    super
  end
end
