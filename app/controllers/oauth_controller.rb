# noinspection RubyResolve,RubyNilAnalysis
class OauthController < ApplicationController
  layout "main"
  before_action :require_login

  def self.oauth_config
    Hashie::Mash.new({
      oauth_version: :v2,
      oauth_scope: %w[
        channels:history
        channels:join
        channels:read
        chat:write
        emoji:read
        files:read
        users.profile:read
        users:read
      ],
      user_oauth_scope: %w[
        groups:history
        groups:read
        identify
        im:history
        im:read
        mpim:history
        mpim:read
      ]
    })
  end

  def self.oauth_url
    URI::HTTPS.build(
      host: "slack.com",
      path: "/oauth/v2/authorize",
      query: {
        scope: oauth_config.oauth_scope.join(","),
        user_scope: oauth_config.user_oauth_scope.join(","),
        client_id: Rails.application.credentials.slack_client_id,
        redirect_uri: Rails.application.routes.url_helpers.oauth_url
      }.to_query
    )
  end

  def index
    response = fetch_access_token

    handle_team_access_token(response) if response.dig(:access_token)
    handle_user_access_token(response) if response.dig(:authed_user, :access_token)

    if @bot_user
      FetchNewPrivateMessagesJob.perform_later(current_account)
      render :confirm
    else
      render :team_confirm
    end
  end

  private

  def fetch_access_token
    client = Slack::Web::Client.new

    raise 'Missing slack_client_id or slack_client_secret.' unless
      Rails.application.credentials.slack_client_id && Rails.application.credentials.slack_client_secret

    options = {
      client_id: Rails.application.credentials.slack_client_id,
      client_secret: Rails.application.credentials.slack_client_secret,
      code: params[:code],
      redirect_uri: Rails.application.routes.url_helpers.oauth_url
    }

    client.oauth_v2_access(options)
  end

  def handle_team_access_token(response)
    @team = Team.find_by_team_id(response.team&.id)

    if @team
      @team.update!(
        token: response.access_token,
        active: true,
        oauth_version: OauthController.oauth_config.oauth_version,
        oauth_scope: response.scope,
        activated_user_id: response.authed_user&.id,
        activated_user_access_token: response.access_token,
        bot_user_id: response.bot_user_id
      )

      logger.info "Access token updated for Team #{@team.name}"
    else
      @team = Team.create!(
        team_id: response.team&.id,
        name: response.team&.name,
        token: response.access_token,
        active: true,
        oauth_version: OauthController.oauth_config.oauth_version,
        oauth_scope: response.scope,
        activated_user_id: response.authed_user&.id,
        activated_user_access_token: response.access_token,
        bot_user_id: response.bot_user_id
      )

      logger.info "Team created #{@team.name}"
    end
  end

  def handle_user_access_token(response)
    # ensure current_account has a user
    raise "account has no user" unless current_account.user_id?

    # ensure current_account.user has matching slack_user
    raise "mismatched slack user ids" unless current_account.user.slack_user == response.authed_user&.id

    @team ||= Team.find_by_team_id(response.team&.id)

    @bot_user = BotUser.find_by_slack_user(response.authed_user&.id)

    if @bot_user
      # existing BotUser
      if current_account.bot_user_id?
        # ensure existing bot_user matches
        raise "existing BotUser doesn't match Account" unless current_account.bot_user == @bot_user
      else
        # link current_account to this bot_user
        current_account.update!(bot_user: @bot_user)
        logger.info "Account #{current_account.email} linked to BotUser #{@bot_user.display_name}"
      end

      @bot_user.update!(
        user_oauth_scope: response.authed_user&.scope,
        user_access_token: response.authed_user&.access_token
      )

      logger.info "User access token updated for BotUser #{@bot_user.display_name}"
    else
      # new BotUser
      raise "pre-existing BotUser for current Account" if current_account.bot_user_id?

      # get slack user info
      team_client = Slack::Web::Client.new(token: @team.token)
      slack_user = team_client.users_info(user: response.authed_user&.id).user

      # set display_name from profile or default
      display_name = if slack_user.profile.display_name.present?
                       slack_user.profile.display_name
                     elsif slack_user.profile.real_name.present?
                       slack_user.profile.real_name
                     else
                       "Unknown User <#{response.authed_user&.id}>"
                     end

      @bot_user = BotUser.create!(
        slack_user: response.authed_user&.id,
        display_name: display_name,
        user_access_token: response.authed_user&.access_token,
        user_oauth_scope: response.authed_user&.scope,
        team: @team
      )

      logger.info "BotUser created for #{display_name}"

      current_account.update!(bot_user: @bot_user)
      logger.info "Account #{current_account.email} linked to BotUser #{@bot_user.display_name}"
    end
  end
end
