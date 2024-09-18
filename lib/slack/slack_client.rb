require 'slack-ruby-client'

class SlackClient < Slack::Web::Client
  def initialize
    # use Firnost & Friends team token, if it exists, or fall back to the api token

    firnost_and_friends = Team.find_by_name("Firnost & Friends")

    token = if firnost_and_friends
              firnost_and_friends.token
            else
              Rails.application.credentials.slack_api_token
            end

    config = {
      # use Firnost & Friends team token, if it exists, or fall back to the api token
      token: token,
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
