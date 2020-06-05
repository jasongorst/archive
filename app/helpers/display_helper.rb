module DisplayHelper
  def fetch_message_dates(channel)
    messages = channel.messages
                      .select("id, ts, FROM_UNIXTIME(ts, '%Y-%m-%d') as date")
                      .group(:date)
    dates = []
    messages.each { |m| dates << m.date }
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

  def month_in?(month, year, dates_with_counts)
    !dates_in_month(month, year, dates_with_counts).empty?
  end

  def dates_in_month(month, year, dates_with_counts)
    dates_with_counts.select { |el| el[0].year == year && el[0].month == month }
  end
end
