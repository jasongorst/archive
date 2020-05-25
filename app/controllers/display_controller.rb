class DisplayController < ApplicationController
  def index
    @channels = Channel.order(name: :asc)
  end

  def show
    @channel = Channel.find(params[:channel_id])
    @messages = @channel.messages.page params[:page]
  end
end
