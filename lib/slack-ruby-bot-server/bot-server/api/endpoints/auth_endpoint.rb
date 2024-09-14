# Authorize
# =========

# https://slack.com/oauth/v2/authorize?
#   scope={comma separated scope list}&
#   user_scope={comma separated scope list}&
#   client_id={client_id}&
#   team={team id (optional)}&
#   redirect_uri={optional URL (default is the Redirect URL in the App Management page)}&
#   state={optional CSRF token}

# scope (bot only)
# ===========
# https://slack.com/oauth/v2/authorize?scope=channels:history,channels:join,channels:read,chat:write,emoji:read,files:read,users:read&client_id=127611636323.7659670818275&redirect_uri=https://exactly-mint-chamois.ngrok-free.app/oauth

# user_scope
# ==========
# https://slack.com/oauth/v2/authorize?user_scope=groups:history,groups:read,identify,im:history,im:read,mpim:history,mpim:read&client_id=127611636323.7659670818275&redirect_uri=https://exactly-mint-chamois.ngrok-free.app/oauth

# both
# ====
# https://slack.com/oauth/v2/authorize?scope=channels:history,channels:join,channels:read,chat:write,emoji:read,files:read,users:read&user_scope=groups:history,groups:read,identify,im:history,im:read,mpim:history,mpim:read&client_id=127611636323.7659670818275&redirect_uri=https://exactly-mint-chamois.ngrok-free.app/oauth

# TODO: handle state
#   STATE_TOKEN_LENGTH = 32
#   state = SecureRandom.urlsafe_base64(STATE_TOKEN_LENGTH)
#   encoded_state = Base64.urlsafe_encode64(state, padding: false)

module BotServer
  module Api
    module Endpoints
      #noinspection RubyResolve
      class AuthEndpoint < Grape::API
        desc 'Handle Slack OAuth requests.'
        format :json

        helpers do
          def logger
            AuthEndpoint.logger
          end
        end

        params do
          requires :code, type: String
          optional :state, type: String
        end

        get do
          body false

          logger.info "Received auth request. Params: #{params}"

          # adapted from SlackRubyBotServer::Api::Endpoints::TeamsEndpoint

          # oauth v1 code omitted
          #   assuming oauth_version == :v2 from this point on

          client = Slack::Web::Client.new

          raise 'Missing slack_client_id or slack_client_secret.' unless Rails.application.credentials.slack_client_id &&
            Rails.application.credentials.slack_client_secret

          options = {
            client_id: Rails.application.credentials.slack_client_id,
            client_secret: Rails.application.credentials.slack_client_secret,
            code: params[:code],
            redirect_uri: "https://exactly-mint-chamois.ngrok-free.app/oauth"
          }

          rc = client.send(SlackRubyBotServer.config.oauth_access_method, options)
          oauth_version = SlackRubyBotServer::Config.oauth_version

          user_id = rc.authed_user&.id
          team_id = rc.team&.id
          team_name = rc.team&.name

          # bot token
          if rc.has_key?(:access_token)
            access_token = rc.access_token
            bot_user_id = rc.bot_user_id
            oauth_scope = rc.scope

            team = Team.find_by_token(access_token) || Team.find_by_team_id(team_id)

            if team
              team.ping_if_active!

              team.update!(
                oauth_version: oauth_version,
                oauth_scope: oauth_scope,
                activated_user_id: user_id,
                activated_user_access_token: access_token,
                bot_user_id: bot_user_id
              )

              # raise "Team #{team.name} is already registered." if team.active?

              team.activate!(access_token)
            else
              team = Team.create!(
                token: access_token,
                oauth_version: oauth_version,
                oauth_scope: oauth_scope,
                team_id: team_id,
                name: team_name,
                activated_user_id: user_id,
                activated_user_access_token: access_token,
                bot_user_id: bot_user_id
              )
            end

            logger.info "Bot access token received. Team: #{team}"
            redirect_params = { team: team.team_id }
          end

          # user token
          if rc.has_key?(:authed_user) && rc.authed_user.has_key?(:access_token)
            team ||= Team.find_by_team_id(team_id)

            user_oauth_scope = rc.authed_user&.scope
            user_access_token = rc.authed_user&.access_token

            bot_user = BotUser.find_by_slack_user(user_id)

            if bot_user
              bot_user.update!(
                user_oauth_scope: user_oauth_scope,
                user_access_token: user_access_token,
                active: true,
                team: team
              )
            else
              team_client = Slack::Web::Client.new(token: team.token)
              user = team_client.users_info(user: user_id).user

              display_name = if user.profile.display_name.present?
                               user.profile.display_name
                             elsif user.profile.real_name.present?
                               user.profile.real_name
                             else
                               "Unknown User"
                             end

              bot_user = BotUser.create!(
                slack_user: user_id,
                display_name: display_name,
                user_access_token: user_access_token,
                user_oauth_scope: user_oauth_scope,
                active: true,
                team: team
              )
            end

            logger.info "User access token received. User: #{bot_user}"
            redirect_params[:user] = bot_user.slack_user
          end

          redirect Rails.application.routes.url_helpers.url_for(only_path: true, controller: :auth, action: :confirm, params: redirect_params)
        end

        add_swagger_documentation
      end
    end
  end
end