module BotServer
  module Api
    module Endpoints
      class RootEndpoint < Grape::API
        include SlackRubyBotServer::Api::Helpers::ErrorHelpers

        helpers do
          def logger
            RootEndpoint.logger
          end
        end

        prefix 'api'
        format :json
        formatter :json, Grape::Formatter::Roar

        get do
          present self, with: SlackRubyBotServer::Api::Presenters::RootPresenter
        end

        mount AuthEndpoint
        mount SlackRubyBotServer::Api::Endpoints::StatusEndpoint
        mount SlackRubyBotServer::Api::Endpoints::TeamsEndpoint

        # namespace :slack do
        #   before do
        #     begin
        #       ::Slack::Events::Request.new(
        #         request,
        #         signing_secret: SlackRubyBotServer::Events.config.signing_secret,
        #         signature_expires_in: SlackRubyBotServer::Events.config.signature_expires_in
        #       ).verify!
        #     rescue ::Slack::Events::Request::TimestampExpired
        #       error!('Invalid Signature', 403)
        #     end
        #   end
        #
        #   mount SlackRubyBotServer::Events::Api::Endpoints::Slack::CommandsEndpoint
        #   mount SlackRubyBotServer::Events::Api::Endpoints::Slack::ActionsEndpoint
        #   mount SlackRubyBotServer::Events::Api::Endpoints::Slack::EventsEndpoint
        # end

        add_swagger_documentation
      end
    end
  end
end
