module DisplayHelper
  def fetch_message_dates(channel)
    messages = channel.messages
                      .select("id, ts, FROM_UNIXTIME(ts, '%Y-%m-%d') as date")
                      .group(:date)
    dates = []
    messages.each { |m| dates << Date.parse(m.date) }
    dates
  end

  def next_date(channel, date)
    dates = fetch_message_dates(channel)
    index = dates.bsearch_index { |d| d >= date }
    return nil if index.nil? || index == (dates.length - 1)
    dates[index + 1]
  end

  def prev_date(channel, date)
    dates = fetch_message_dates(channel)
    index = dates.bsearch_index { |d| d >= date }
    return nil if index == 0
    dates[index - 1]
  end

  def long_date(date)
    "#{date.strftime('%B')} #{date.mday.ordinalize}, #{date.year}"
  end
end
