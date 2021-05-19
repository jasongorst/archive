class SearchController < ApplicationController
  layout 'main'

  RESULTS_PER_PAGE = 20
  MAX_RESULTS = 10_000

  def index
    @channels = Channel.all.order(name: :asc)
    @users = User.all.order(display_name: :asc)

    if params.key? :search
      # munge search params
      query, filters = process_search_params(params[:search])

      # execute search
      @results = search_with_excerpts(query, filters)

      # build [url, result] array
      @urls_results = build_url_result_array(@results)

    else
      # set defaults for new search form
      params[:search] = search_defaults
    end
  end

  private

  def process_search_params(search)
    # escape SphinxQL in query
    query = ThinkingSphinx::Query.escape(search[:query])
    # unescape double quotes to allow phrase searching
    query.gsub!(/\\"/, '"')

    # convert strings to times
    after  = search[:after].to_time.localtime
    before = search[:before].to_time.localtime

    # set search params to times to pass back to the datepicker
    params[:search][:after] = after
    params[:search][:before] = before

    # filter search on attributes
    filters = { posted_at: after...before }
    filters.merge!({ channel_id: search[:channel_id].to_i }) unless search[:channel_id].empty?
    filters.merge!({ user_id: search[:user_id].to_i }) unless search[:user_id].empty?

    [query, filters]
  end

  def search_with_excerpts(query, filters)
    # get message search results with maximum size excerpts (i.e., entire messages)
    results = Message.search query,
                             with: filters,
                             order: 'posted_at DESC',
                             page: params[:page],
                             per_page: RESULTS_PER_PAGE,
                             max_matches: MAX_RESULTS,
                             excerpts: {
                               before_match: '<mark>',
                               after_match: '</mark>',
                               limit: 2**16,
                               around: 2**16,
                               force_all_words: true
                             }
    # highlight search terms in results using excerpts pane
    results.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane
    results
  end

  def build_url_result_array(results)
    # build urls for results
    urls = results.map do |result|
      page = page_from_index(index_of_message_by_date(result))
      channel_date_path(result.channel, result.posted_on, page: page, anchor: "ts_#{result.ts}")
    end

    # zip urls with results for use in view
    urls.zip(results.to_a)
  end

  def index_of_message_by_date(message)
    # find index of message on posted_on date
    m_ary = message.channel.messages.where(posted_on: message.posted_on).pluck(:posted_at)
    m_ary.bsearch_index { |m| m >= message.posted_at } + 1
  end

  def page_from_index(index)
    # calculate page of posted_on date for a given index
    (index.to_f / Message.default_per_page).ceil
  end

  def search_defaults
    {
      query: '',
      after: Message.order(:posted_at).pick(:posted_at),
      before: Time.now.localtime,
      channel_id: '',
      user_id: ''
    }
  end
end
