class DisplayController < ApplicationController
  layout 'main'

  def index
    @channels = Channel.order(name: :asc)
  end

  def show
    @channel = Channel.friendly.find(params[:channel_id])
    @dates_with_counts = Rails.cache.fetch("dates_with_counts_in_channel_#{@channel.id}") do
      @channel.messages.reorder(posted_on: :desc).group(:posted_on).count
    end
  end

  def by_date
    @channel = Channel.friendly.find(params[:channel_id])
    @date = params[:date].to_date
    ids = Rails.cache.fetch("messages_in_channel_#{@channel.id}_on_#{@date}") do
      @channel.messages.where(posted_on: @date).pluck(:id)
    end
    @messages = Message.where(id: ids).order(posted_at: :asc).page(params[:page])
  end
end
