class DisplayController < ApplicationController
  layout "main"

  def index
    @channels = Channel.with_messages
  end

  def show
    @channel = Channel.friendly.find(params[:channel_id])
  end

  def by_date
    @channel = Channel.friendly.find(params[:channel_id])
    @date = params[:date].to_date
    @messages = @channel.messages_posted_on(@date)

    # paginate messages
    @messages = @messages.page(params[:page])
  end
end
