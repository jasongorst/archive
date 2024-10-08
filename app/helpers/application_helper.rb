module ApplicationHelper
  def current_account
    current_user
  end

  def bot_authorized?
    signed_in? && current_account&.bot_user_id?
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

  def long_date(date)
    "#{date.strftime('%B')} #{date.mday.ordinalize}"
  end

  def long_date_with_year(date)
    "#{long_date(date)}, #{date.year}"
  end

  def short_date(date)
    "#{date.strftime('%b %e')}"
  end

  def short_date_with_year(date)
    "#{date.strftime('%b %e, %Y')}"
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
    Time.zone.now.month
  end

  def this_year
    Time.zone.now.year
  end

  def time_ago(time)
    if time.nil?
      "never"
    else
      "#{time_ago_in_words(time)} ago"
    end
  end
end
