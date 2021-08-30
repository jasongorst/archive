module DisplayHelper
  def dates_with_messages(channel)
    channel.messages.group(:posted_on).pluck(:posted_on)
  end

  def next_date(channel, date)
    dates = dates_with_messages(channel)
    index = dates.bsearch_index { |d| d >= date }
    if index.nil? || index == (dates.length - 1)
      nil
    else
      dates[index + 1]
    end
  end

  def prev_date(channel, date)
    dates = dates_with_messages(channel)
    index = dates.bsearch_index { |d| d >= date }
    if index.zero?
      nil
    else
      dates[index - 1]
    end
  end

  def long_date(date)
    "#{date.strftime('%B')} #{date.mday.ordinalize}"
  end

  def long_date_with_year(date)
    "#{long_date(date)}, #{date.year}"
  end

  def month_contained_in?(month, year, dates_with_counts)
    not dates_in_month(month, year, dates_with_counts).empty?
  end

  def year_contained_in?(year, dates_with_counts)
    not dates_in_year(year, dates_with_counts).empty?
  end

  def dates_in_month(month, year, dates_with_counts)
    dates_with_counts.select { |date, _| date.year == year && date.month == month }
  end

  def dates_in_year(year, dates_with_counts)
    dates_with_counts.select { |date, _| date.year == year }
  end

  def this_month
    Time.now.month
  end

  def this_year
    Time.now.year
  end

  def oldest_message_date(channel)
    channel.messages.minimum(:posted_on)
  end
end
