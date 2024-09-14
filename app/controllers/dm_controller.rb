class DmController < ApplicationController
  layout 'main'

  def index
    @private_channels = PrivateChannel.with_messages
  end

  def show
    @private_channel = PrivateChannel.find(params[:private_channel_id])
    @dates_with_counts = @private_channel.private_messages.reorder(posted_on: :desc).group(:posted_on).count
  end

  def by_date
    @private_channel = PrivateChannel.find(params[:private_channel_id])
    @date = params[:date].to_date
    @private_messages = @private_channel.private_messages.where(posted_on: @date).page(params[:page])
  end
end