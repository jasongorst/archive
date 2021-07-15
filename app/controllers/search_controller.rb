class SearchController < ApplicationController
  layout 'main'

  RESULTS_PER_PAGE = 20
  MAX_RESULTS = 10_000

  def index
    @channels = Channel.order(name: :asc)
    @users = User.order(display_name: :asc)

    if params.key? :search
      # munge search params
      query, filters = process_search_params(params[:search])

      # execute search
      @messages = search_with_excerpts(query, filters)
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
    messages = Message.search query,
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
    messages.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane

    messages
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
