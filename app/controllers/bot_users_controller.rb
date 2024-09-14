class BotUsersController < ApplicationController
  def index
    @team = Team.find_by_team_id(params[:team])
    @bot_users = @team.bot_users
  end
end
