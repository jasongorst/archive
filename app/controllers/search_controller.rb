class SearchController < ApplicationController
  layout 'main'

  RESULTS_PER_PAGE = 20
  MAX_RESULTS = 10_000

  def index
    @channels = Channel.order(name: :asc)
    @users = User.order(display_name: :asc)

    if params.has_key? :search
      query = query_from_search_params(params[:search])
      filters = filters_from_search_params(params[:search])
      order = order_from_search_params(params[:search])
      @messages = search_with_excerpts(query, filters, order)
    else
      # set defaults for new search form
      params[:search] = search_defaults
    end
  end

  private

  def parse_dates(start_date, end_date)
    # parse start/end dates or use defaults
    begin
      start_date = start_date.to_date
    rescue Date::Error
      start_date = oldest_message_date
    end

    begin
      end_date = end_date.to_date
    rescue Date::Error
      end_date = Date.today
    end

    [start_date, end_date]
  end

  def query_from_search_params(search)
    # escape SphinxQL in query
    query = ThinkingSphinx::Query.escape(search[:query])
    # unescape double quotes to allow phrase searching
    query.gsub(/\\"/, '"')
  end

  def filters_from_search_params(search)
    # filter search on attributes
    start_date, end_date = parse_dates(search[:start], search[:end])
    filters = { posted_on: (start_date.to_time)..(end_date.to_time + 1.day - 1.second) }
    filters.merge!({ channel_id: search[:channel_id].to_i }) unless search[:channel_id].blank?
    filters.merge!({ user_id: search[:user_id].to_i }) unless search[:user_id].blank?

    filters
  end

  def order_from_search_params(search)
    if search[:sort_by] == 'date'
      "posted_at #{search[:order]}, w DESC"
    else
      "w DESC"
    end
  end

  def search_with_excerpts(query, filters, order)
    # get message search results with maximum size excerpts (i.e., entire messages)
    messages = Message.search query,
                              select: '*, weight() as w',
                              with: filters,
                              order: order,
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
      user_id: nil,
      sort_by: 'best',
      order: 'DESC'
    }
  end

  def oldest_message_date
    Rails.cache.fetch("oldest_message_date") do
      Message.minimum(:posted_on)
    end
  end
end
