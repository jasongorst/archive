# noinspection RubyNilAnalysis
class PrivateSearchController < ApplicationController
  layout "main"
  before_action :require_login
  before_action :require_user

  RESULTS_PER_PAGE = 20
  MAX_RESULTS = 10_000

  def index
    @private_channels = current_account.user.private_channels.unarchived.with_messages
    @archived_channels = current_account.user.private_channels.archived.with_messages
    @users = User.where(is_bot: false, deleted: false).order(display_name: :asc)

    if params.has_key? :search
      query = query_from_params(params[:search])
      filters = filters_from_params(params[:search])
      order = order_from_params(params[:search])

      @private_messages = search_with_excerpts(query, filters, order)
    else
      # set form defaults
      params[:search] = defaults
    end
  end

  private

  def query_from_params(search)
    # escape SphinxQL in query
    query = ThinkingSphinx::Query.escape(search[:query])

    # now unescape double quotes to allow phrase searching
    query.gsub(/\\"/, '"')
  end

  def filters_from_params(search)
    # parse dates from params with fallback to defaults
    start_date = parse_date(search[:start]) || default_start_date
    end_date = parse_date(search[:end]) || default_end_date

    # filter search on attributes
    filters = { posted_on: (start_date.to_time)..(end_date.end_of_day.to_time) }

    filters[:user_id] = search[:user_id].to_i if search[:user_id].present?

    # ensure that only private channels belonging to the current user are included in search
    if search[:private_channel_id].present?
      if search[:private_channel_id].to_i.in?(current_account.user.private_channels.pluck(:id))
        filters[:private_channel_id] = search[:private_channel_id].to_i
      else
        raise ArgumentError, "Current account doesn't have access to the private channel #{search[:private_channel_id].to_i}."
      end
    elsif search[:include_archived] == "0"
      filters[:private_channel_id] = current_account.user.private_channels.unarchived.with_messages.pluck(:id)
    else
      filters[:private_channel_id] = current_account.user.private_channels.with_messages.pluck(:id)
    end

    filters
  end

  def parse_date(date)
    date.to_date
  rescue Date::Error
    nil
  end

  def order_from_params(search)
    if search[:sort_by] == "date"
      "posted_at #{search[:order]}, w DESC"
    else
      "w DESC"
    end
  end

  def search_with_excerpts(query, filters, order)
    # search messages with really big excerpts (i.e. the entire message)
    private_messages = PrivateMessage.search query,
                                             select: "*, weight() as w",
                                             with: filters,
                                             order: order,
                                             page: params[:page],
                                             per_page: RESULTS_PER_PAGE,
                                             max_matches: MAX_RESULTS,
                                             excerpts: {
                                               before_match: "<mark>",
                                               after_match: "</mark>",
                                               limit: 0,
                                               html_strip_mode: "retain"
                                             }

    # highlight search terms in results using excerpts pane
    private_messages.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane

    private_messages
  end

  def default_start_date
    PrivateMessage.where(private_channel: current_account.user.private_channels).minimum(:posted_on)
  end

  def default_end_date
    Date.today
  end

  def defaults
    {
      query: nil,
      start: default_start_date,
      end: default_end_date,
      private_channel_id: nil,
      include_archived: 0,
      user_id: nil,
      sort_by: "best",
      order: "DESC"
    }
  end
end
