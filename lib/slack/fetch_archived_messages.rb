module Slack
  class FetchArchivedMessages < FetchMessages
    GYRF_SLACK_ID = "U494XRGTB".freeze

    def initialize
      super
      token = BotUser.find_by_slack_user(GYRF_SLACK_ID).user_access_token
      @client = Slack::Web::Client.new(token: token)
    end

    def fetch_channels
      channels = []

      @client.conversations_list(types: "public_channel", exclude_archived: false) do |response|
        channels.concat(response.channels)
      end

      channels.select(&:is_archived)
    end
  end
end

