module PrivateSearchHelper
  def index_of_private_message_by_date(private_message)
    # find index (1-based) of private message by posted_on
    private_messages = private_message.private_channel.private_messages.where(posted_on: private_message.posted_on).pluck(:posted_at)
    private_messages.bsearch_index { |m| m >= private_message.posted_at } + 1
  end

  def page_from_private_message_index(index)
    # calculate page of posted_on date for a given index (1-based)
    (index.to_f / PrivateMessage.default_per_page).ceil
  end
end
