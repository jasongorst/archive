require_relative "boot"

require "rails"

require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
# require "action_cable/engine"
# require "action_mailbox/engine"
require "action_text/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Archive
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Eastern Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Set layouts for Clearance views
    config.to_prepare do
      Clearance::PasswordsController.layout "main"
      Clearance::SessionsController.layout "main"
      Clearance::UsersController.layout "main"
    end

    # set up postmark
    config.action_mailer.delivery_method = :postmark

    config.action_mailer.postmark_settings = {
      api_token: Rails.application.credentials.postmark_api_token!
    }
  end
end
