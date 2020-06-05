class DisplayController < ApplicationController
  def index
    @channels = Channel.order(name: :asc)
  end

  def show
    @channel = Channel.friendly.find(params[:channel_id])
    messages = @channel.messages
                       .unscoped
                       .where("channel_id = #{@channel.id}")
                       .select("id, ts, FROM_UNIXTIME(ts, '%Y-%m-%d') as date, count(*) as count")
                       .group(:date)
                       .order(date: :desc)
    @dates_with_counts = []
    messages.each { |m| @dates_with_counts << [m.date, m.count] }
    @this_month = Time.now.month
    @this_year = Time.now.year
    @oldest_year = @channel.messages.first.date.year
  end

  def show_by_date
    @channel = Channel.friendly.find(params[:channel_id])
    @date = Date.parse(params[:date])
    @messages = @channel.messages
                        .where("ts >= #{@date.to_time.to_i}")
                        .where("ts < #{@date.succ.to_time.to_i}")
                        .order(ts: :asc)
                        .page params[:page]
  end
end
