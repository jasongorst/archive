class AuthController < ApplicationController
  layout "main"
  def confirm
    @team = Team.find_by_team_id(params[:team])

    if params[:user].blank?
      render :team_confirm
    else
      @bot_user = BotUser.find_by_slack_user(params[:user])
      @account = Account.find(params[:account]) if params[:account]
    end
  end

  def team_confirm
    @team = Team.first
  end
end
