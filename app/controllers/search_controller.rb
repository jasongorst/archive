class SearchController < ApplicationController
  layout 'main'

  RESULTS_PER_PAGE = 20
  MAX_RESULTS = 10_000

  def index
    @channels = Channel.order(name: :asc)
    @users = User.order(display_name: :asc)

    if params.key? :search
      parse_search_times
      query = query_from_search_params(params[:search])
      filters = filters_from_search_params(params[:search])
      @messages = search_with_excerpts(query, filters)
    else
      # set defaults for new search form
      params[:search] = search_defaults
    end
  end

  private

  def parse_search_times
    params[:search][:start] = params[:search][:start].try(:to_date) || oldest_message_date
    params[:search][:end] = params[:search][:end].try(:to_date) || Date.today
  end

  def query_from_search_params(search)
    # escape SphinxQL in query
    query = ThinkingSphinx::Query.escape(search[:query])
    # unescape double quotes to allow phrase searching
    query.gsub!(/\\"/, '"')

    query
  end

  def filters_from_search_params(search)
    # filter search on attributes
    filters = { posted_on: search[:start]..(search[:end] + 1) }
    filters.merge!({ channel_id: search[:channel_id].to_i }) unless search[:channel_id].blank?
    filters.merge!({ user_id: search[:user_id].to_i }) unless search[:user_id].blank?

    filters
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
      start: oldest_message_date,
      end: Date.today,
      channel_id: nil,
      user_id: nil
    }
  end

  def oldest_message_date
    Rails.cache.fetch("oldest_message_date") do
      Message.minimum(:posted_on)
    end
  end
end
