class ApplicationController < ActionController::Base
  include Clearance::Controller

  unless Rails.env.production?
    around_action :n_plus_one_detection

    def n_plus_one_detection
      Prosopite.scan
      yield
    ensure
      Prosopite.finish
    end
  end

  def current_account
    current_user
  end

  def require_user
    deny_access("Your account isn't linked to a Slack user.") unless current_account&.user
  end

  def authorize_admin
    redirect_back_or_to(root_path, alert: "Only admins can access that content.") unless current_user&.admin?
  end
end
