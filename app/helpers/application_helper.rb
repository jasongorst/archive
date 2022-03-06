module ApplicationHelper
  def channels_with_messages
    ids = Rails.cache.fetch("channels_with_messages") do
      Channel.joins(:messages).distinct.pluck(:id)
    end
    Channel.where(id: ids).order(name: :asc)
  end
end
