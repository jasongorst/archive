module ApplicationHelper
  def message_time(message)
    Time.at(message.ts)
  end

  def oldest_message_time
    Time.at(Message.order(ts: :asc).first.ts)
  end

  def newest_message_time
    Time.at(Message.order(ts: :asc).last.ts)
  end

  def channels_with_messages
    Channel.joins(:messages).distinct.order(name: :asc)
  end
end
