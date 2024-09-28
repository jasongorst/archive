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
        format "json"

        helpers do
          def logger
            Rails.logger
          end

          def signed_in?
            env[:clearance].signed_in?
          end

          def current_account
            env[:clearance].current_user
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

          raise 'Missing slack_client_id or slack_client_secret.' unless
            Rails.application.credentials.slack_client_id && Rails.application.credentials.slack_client_secret

          options = {
            client_id: Rails.application.credentials.slack_client_id,
            client_secret: Rails.application.credentials.slack_client_secret,
            code: params[:code],
            redirect_uri: BotServer::REDIRECT_URL
          }

          rc = client.send(SlackRubyBotServer.config.oauth_access_method, options)
          oauth_version = SlackRubyBotServer::Config.oauth_version

          user_id = rc.authed_user&.id
          team_id = rc.team&.id
          team_name = rc.team&.name

          redirect_params = {}

          # bot token
          if rc.has_key?(:access_token)
            access_token = rc.access_token
            bot_user_id = rc.bot_user_id
            oauth_scope = rc.scope

            team = Team.find_by_token(access_token) || Team.find_by_team_id(team_id)

            if team
              team.update!(
                token: access_token,
                oauth_version: oauth_version,
                oauth_scope: oauth_scope,
                activated_user_id: user_id,
                activated_user_access_token: access_token,
                bot_user_id: bot_user_id
              )

              team.activate!(access_token)
              logger.info "Access token updated for Team #{team.name}"
            else
              team = Team.create!(
                team_id: team_id,
                name: team_name,
                token: access_token,
                oauth_version: oauth_version,
                oauth_scope: oauth_scope,
                activated_user_id: user_id,
                activated_user_access_token: access_token,
                bot_user_id: bot_user_id
              )

              logger.info "Team created #{team.name}"
            end

            redirect_params[:team] = team_id
          end

          # user token
          if rc.has_key?(:authed_user) && rc.authed_user.has_key?(:access_token)
            raise "not signed in" unless signed_in?

            # ensure current_account.user has matching slack_user
            raise "mismatched slack user ids" unless current_account.user.slack_user == user_id

            team ||= Team.find_by_team_id(team_id)

            user_oauth_scope = rc.authed_user&.scope
            user_access_token = rc.authed_user&.access_token
            bot_user = BotUser.find_by_slack_user(user_id)

            if bot_user
              # existing BotUser
              if current_account.bot_user_id?
                # ensure existing bot_user matches
                raise "existing BotUser doesn't match Account" unless current_account.bot_user == bot_user
              else
                # link current_account to this bot_user
                current_account.update!(bot_user: bot_user)
                logger.info "Account #{current_account.email} linked to BotUser #{bot_user.display_name}"
              end

              bot_user.update!(
                user_oauth_scope: user_oauth_scope,
                user_access_token: user_access_token,
                active: true
              )

              logger.info "User access token updated for BotUser #{bot_user.display_name}"
            else
              # new BotUser
              raise "pre-existing BotUser for current Account" if current_account.bot_user_id?

              # get slack user info
              team_client = Slack::Web::Client.new(token: team.token)
              slack_user = team_client.users_info(user: user_id).user

              # set display_name from profile or default
              display_name = if slack_user.profile.display_name.present?
                               slack_user.profile.display_name
                             elsif slack_user.profile.real_name.present?
                               slack_user.profile.real_name
                             else
                               "Unknown User <#{user_id}>"
                             end

              bot_user = BotUser.create!(
                slack_user: user_id,
                display_name: display_name,
                user_access_token: user_access_token,
                user_oauth_scope: user_oauth_scope,
                active: true,
                team: team
              )

              logger.info "BotUser created for #{display_name}"

              current_account.update!(bot_user: bot_user)
              logger.info "Account #{account.email} linked to BotUser #{bot_user.display_name}"
            end

            redirect_params[:user] = user_id
          end

          redirect Rails.application.routes.url_helpers.url_for(only_path: true, controller: :auth, action: :confirm, params: redirect_params)
        end

        add_swagger_documentation
      end
    end
  end
end
