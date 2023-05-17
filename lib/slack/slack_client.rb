require 'slack-ruby-client'

class SlackClient < Slack::Web::Client
  def initialize
    config = {
      token: Rails.application.credentials.slack_api_token,
      logger: Logger.new(
        STDOUT,
        level: if Rails.env.development? || ENV["LOG_INFO"]
                Logger::INFO
              else
                Logger::WARN
               end
      )
    }

    # set up new Web API client
    super(config)
  end
end
