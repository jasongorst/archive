module ApplicationHelper
  def channels_with_messages
    Channel.joins(:messages).distinct.order(name: :asc)
  end
end
