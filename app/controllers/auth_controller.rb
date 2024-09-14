class AuthController < ApplicationController
  def confirm
    @team = Team.find_by_team_id(params[:team])
    @bot_user = BotUser.find_by_slack_user(params[:user])
  end
end
