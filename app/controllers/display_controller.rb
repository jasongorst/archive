class DisplayController < ApplicationController
  def index
    @channels = Channel.order(name: :asc)
  end

  def show
    @channel = Channel.friendly.find(params[:channel_id])
    messages = @channel.messages
                       .select("id, ts, FROM_UNIXTIME(ts, '%Y-%m-%d') as date, count(*) as count")
                       .group(:date)
    @dates_counts = {}
    messages.each { |m| @dates_counts.merge!({ Date.parse(m.date) => m.count }) }
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
