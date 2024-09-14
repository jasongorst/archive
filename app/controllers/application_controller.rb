class ApplicationController < ActionController::Base
  include Clearance::Controller

  def current_account
    current_user
  end
end
