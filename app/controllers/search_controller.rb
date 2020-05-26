class SearchController < ApplicationController
  RESULTS_PER_PAGE = 20
  def index
    @channels = Channel.all.order(name: :asc)
    @users = User.all.order(display_name: :asc)

    @results = nil

    if params.key? :search
      # munge search params
      search = params[:search]

      # escape SphinxQL in query
      query = ThinkingSphinx::Query.escape(search[:query])

      # create DateTimes from params
      after  = date_time_from_params(search, :after)
      before = date_time_from_params(search, :before)

      # convert time filters to UTC timestamps
      after_ts = after.to_time.utc.to_f
      before_ts = before.to_time.utc.to_f

      # filter search on attributes
      filters = { ts: after_ts..before_ts }
      unless search[:channel_id].empty?
        filters.merge!({ channel_id: search[:channel_id].to_i })
      end
      unless search[:user_id].empty?
        filters.merge!({ user_id: search[:user_id].to_i })
      end

      # set defaults for datetime_selects
      params[:search][:after]  = after
      params[:search][:before] = before

      # get message search results
      @results = Message.search query, with: filters,
                                order: 'ts DESC',
                                page: params[:page],
                                per_page: RESULTS_PER_PAGE

      # build message hash
      m_hash = message_hash

      @urls = []
      @results.each do |result|
        index = m_hash[result.channel_id].bsearch_index { |m| m.ts >= result.ts}
        page = (index.to_f / Message.default_per_page.to_f).ceil
        channel = Channel.find(result.channel_id)
        @urls << url_for([channel, { page: page, anchor: "ts_#{result.ts}" }])
      end

      # zip results with urls to use as a collection
      @urls_results = @urls.zip(@results.to_a)
    else
      # set defaults for search form
      params[:search] = default_search_params
    end
  end

  private

  def default_search_params
    search = {}
    search[:query]       = ''
    search[:after]       = 1.week.ago.localtime
    search[:before]      = Time.now
    search[:channel_id]  = ''
    search[:user_id]     = ''
    search
  end

  def date_time_from_params(params, date_key)
    date_keys = params.keys.select { |k| k.to_s.match?(date_key.to_s + '\(\di\)') }.sort
    date_array = params.values_at(*date_keys).map(&:to_i)
    DateTime.new(*date_array)
  end

  def message_hash
    # get hash of message ids and ts's by channel_id
    # {:channel_id => [:messages sorted by ascending ts]}
    m_hash = Hash.new
    Channel.all.each do |c|
      m_ary = c.messages.select(:ts).to_a
      m_hash.merge!({ c.id => m_ary })
    end
    m_hash
  end

  def index_of_array_by_ts(m_ary, ts)
    m_ary.bsearch_index { |m| m.ts >= ts }
  end
end
