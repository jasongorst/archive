class TeamsController < ApplicationController
  def index
    @teams = Team.active
  end

  def show
    @team = Team.find(params[:id])
  end
end
