module ApplicationHelper
  def channels_with_messages
    Channel.joins(:messages).order(name: :asc).distinct
  end
end
