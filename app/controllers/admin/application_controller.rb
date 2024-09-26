# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include Clearance::Controller
    before_action :require_login
    before_action :authorize_admin

    def authorize_admin
      redirect_back_or_to(root_path, alert: "Only admins can access Dashboards.") unless current_user&.admin?
    end

    def current_account
      current_user
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
