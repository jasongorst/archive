module ApplicationHelper
  def channels_with_messages
    Rails.cache.fetch("channels_with_messages") do
      Channel.joins(:messages).distinct.order(name: :asc)
    end
  end

  def channel_page?
    params[:channel_id]
  end

  def current_channel
    params[:channel_id]
  end

  def private_channel_page?
    params[:private_channel_id]
  end

  def current_private_channel
    params[:private_channel_id]
  end

  def current_account
    current_user
  end
end
