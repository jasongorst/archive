require "slack-ruby-client"

module Slack
  class Client < Slack::Web::Client
    def initialize(token = nil)
      config = {
        # use token from args, or bot token for Firnost, or fall back to the api token
        token: token || ::Team.find_by_name("Firnost & Friends").token || Rails.application.credentials.slack_api_token
      }

      # set up new Web API client
      super(config)
    end
  end
end
