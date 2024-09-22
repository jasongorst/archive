class SessionsController < Clearance::SessionsController
  def first_sign_in
    redirect_back_or_to :signed_out_root_path unless signed_in?
    redirect_back_or_to :root_path if current_account.has_signed_in?

    # set has_signed_in?
    current_account.has_signed_in = true

    # reset account password
    current_account.encrypted_password = ""
    current_account.forgot_password!

    # send password reset email
    ClearanceMailer.change_password(current_account).deliver_now

    # build url for Add to Slack button
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
    if current_account.has_signed_in?
      "/"
    else
      "/first_sign_in"
    end
  end
end
