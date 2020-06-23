class DisplayController < ApplicationController
  layout 'main'

  def index
    @channels = Channel.order(name: :asc)
  end

  def show
    @channel = Channel.friendly.find(params[:channel_id])
    messages = @channel.messages
                       .select("id, ts, FROM_UNIXTIME(ts, '%Y-%m-%d') as date, count(*) as count")
                       .group(:date)
                       .reorder(date: :desc)
    @dates_with_counts = messages.map { |m| [m.date, m.count] }
    @this_month = Time.now.month
    @this_year = Time.now.year
  end

  def show_by_date
    @channel = Channel.friendly.find(params[:channel_id])
    @date = params[:date].to_date
    @messages = @channel.messages
                        .where(ts: (@date.to_time.to_i)..(@date.succ.to_time.to_i))
                        .page params[:page]
  end
end
