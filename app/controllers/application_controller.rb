class ApplicationController < ActionController::Base
  include Clearance::Controller

  def current_account
    current_user
  end

  def require_user
    unless current_account.user
      deny_access("Your account isn't linked to a Slack user, or you haven't authorized the bot yet.")
    end
  end
end
