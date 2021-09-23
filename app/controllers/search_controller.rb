class SearchController < ApplicationController
  layout 'main'

  RESULTS_PER_PAGE = 20
  MAX_RESULTS = 10_000

  def index
    @channels = Channel.order(name: :asc)
    @users = User.order(display_name: :asc)

    if params.key? :search
      parse_search_times
      query, filters = query_from_search_params(params[:search])
      @messages = search_with_excerpts(query, filters)
    else
      # set defaults for new search form
      params[:search] = search_defaults
    end
  end

  private

  def parse_search_times
    params[:search][:after] = params[:search][:after].try(:to_time) || oldest_message_time
    params[:search][:before] = params[:search][:before].try(:to_time) || Time.now
  end

  def query_from_search_params(search)
    # escape SphinxQL in query
    query = ThinkingSphinx::Query.escape(search[:query])
    # unescape double quotes to allow phrase searching
    query.gsub!(/\\"/, '"')

    # posted_at is stored in local server time (America/New York on evilpaws.org)
    local_offset = Time.now.utc_offset
    after = search[:after] + local_offset
    before = search[:before] + local_offset

    # filter search on attributes
    filters = { posted_at: after..before }
    filters.merge!({ channel_id: search[:channel_id].to_i }) unless search[:channel_id].blank?
    filters.merge!({ user_id: search[:user_id].to_i }) unless search[:user_id].blank?

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
      query: nil,
      after: oldest_message_time,
      before: Time.now,
      channel_id: nil,
      user_id: nil
    }
  end

  def oldest_message_time
    Message.minimum(:posted_at)
  end
end
