class AuthenticatedController < ApplicationController
  before_action :require_login
  before_action :authorize_admin
end
