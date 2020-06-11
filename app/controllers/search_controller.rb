class SearchController < ApplicationController
  RESULTS_PER_PAGE = 20
  def index
    @channels = Channel.all.order(name: :asc)
    @users = User.all.order(display_name: :asc)

    if params.key? :search
      # munge search params
      query, filters = process_search_params(params[:search])

      # get message search results with maximum size excerpts (i.e., no excerpting)
      @results = Message.search query, with: filters,
                                       order: 'ts DESC',
                                       page: params[:page],
                                       per_page: RESULTS_PER_PAGE,
                                       excerpts: {
                                         before_match: '<mark>',
                                         after_match: '</mark>',
                                         limit: 2**16,
                                         around: 2**16,
                                         force_all_words: true
                                       }
      # highlight search terms in results
      @results.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane

      # build urls for results
      @urls = @results.map do |result|
        index = index_of_message_by_date(result)
        page = (index.to_f / Message.default_per_page).ceil
        "/#{result.channel.name}/#{result.date}?page=#{page}#ts_#{result.ts}"
      end

      # zip results with urls to use as a collection
      @urls_results = @urls.zip(@results.to_a)
    else
      # set defaults for new search form
      params[:search] = {
        query: '',
        after: 1.week.ago.localtime,
        before: Time.now,
        channel_id: '',
        user_id: ''
      }
    end
  end

  private

  def process_search_params(search)
    # escape SphinxQL in query
    query = ThinkingSphinx::Query.escape(search[:query])
    # unescape double quotes to allow phrase searching
    query = query.gsub(/\\"/, '"')

    # parse datetime strings
    after  = Time.parse(search[:after])
    before = Time.parse(search[:before])

    # set search params to parsed values
    params[:search][:after] = after
    params[:search][:before] = before

    # convert time filters to UTC timestamps
    after_ts = after.utc.to_f
    before_ts = before.utc.to_f

    # filter search on attributes
    filters = { ts: after_ts..before_ts }
    filters.merge!({ channel_id: search[:channel_id].to_i }) unless search[:channel_id].empty?
    filters.merge!({ user_id: search[:user_id].to_i }) unless search[:user_id].empty?

    [query, filters]
  end

  def index_of_message_by_date(message)
    m_ary = message.channel
                   .messages
                   .select(:ts)
                   .where("ts >= #{message.date.to_time.to_i}")
                   .where("ts < #{message.date.succ.to_time.to_i}")
                   .to_a
    m_ary.bsearch_index { |m| m.ts >= message.ts } + 1
  end
end
