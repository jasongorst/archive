class DisplayController < ApplicationController
  layout 'main'

  def index
    @channels_with_times = Rails.cache.fetch("channels_with_times") do
      channels_with_times = []
      helpers.channels_with_messages.each do |channel|
        channels_with_times << [channel, channel.messages.reorder(posted_at: :desc).pick(:posted_at)]
      end
      channels_with_times
    end
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
    @messages = Rails.cache.fetch("messages_in_channel_#{@channel.id}_on_#{@date}") do
      @channel.messages.where(posted_on: @date).order(posted_at: :asc)
    end

    # paginate messages
    @messages = @messages.page(params[:page])
  end
end
