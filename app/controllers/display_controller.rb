class DisplayController < ApplicationController
  layout 'main'

  def index
    @channels = Channel.order(name: :asc)
  end

  def show
    @channel = Channel.friendly.find(params[:channel_id])
    @dates_with_counts = @channel.messages.reorder(posted_on: :desc).group(:posted_on).count
    @this_month = Time.now.month
    @this_year = Time.now.year
  end

  def show_by_date
    @channel = Channel.friendly.find(params[:channel_id])
    @date = params[:date].to_date
    @messages = @channel.messages.where(posted_on: @date).page params[:page]
  end
end
