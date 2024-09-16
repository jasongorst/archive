class SessionsController < Clearance::SessionsController
  def first_sign_in
    @oauth_url = URI::HTTPS.build(
      host: "slack.com",
      path: case SlackRubyBotServer::Config.oauth_version
            when :v2
              "/oauth/v2/authorize"
            when :v1
              "/oauth/authorize"
            else
              raise ArgumentError, "Invalid SlackRubyBotServer::Config.oauth_version, must be one of :v1 or :v2."
            end,
      query: {
        scope: SlackRubyBotServer::Config.oauth_scope&.join(","),
        user_scope: BotServer::USER_OAUTH_SCOPE.join(","),
        client_id: Rails.application.credentials.slack_client_id,
        redirect_url: BotServer::REDIRECT_URL
      }.to_query
    )
  end

  def url_after_create
    if current_account.user
      "/"
    else
      "/first_sign_in"
    end
  end
end
