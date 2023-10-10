module ApplicationHelper
  def channels_with_messages
    Channel.joins(:messages).distinct.order(name: :asc)
  end

  def channel_page?
    params[:channel_id]
  end

  def current_channel
    params[:channel_id]
  end
end
