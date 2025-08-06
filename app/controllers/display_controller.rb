class DisplayController < ApplicationController
  layout :main_layout

  def index
    @channels = Channel.unarchived.with_messages
    @archived_channels = Channel.archived.with_messages
  end

  def show
    @channel = Channel.friendly.find(params[:channel_id])
    @message_counts_by_date = @channel.message_counts_by_date
  end

  def by_date
    @channel = Channel.friendly.find(params[:channel_id])
    @date = params[:date].to_date
    @messages = @channel.messages_posted_on(@date)

    # paginate messages
    @messages = @messages.page(params[:page])
  end
end
