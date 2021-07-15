module SearchHelper
  def index_of_message_by_date(message)
    # find index of message by posted_on
    messages = message.channel.messages.where(posted_on: message.posted_on).pluck(:posted_at)
    messages.bsearch_index { |m| m >= message.posted_at } + 1
  end

  def page_from_index(index)
    # calculate page of posted_on date for a given index
    (index.to_f / Message.default_per_page).ceil
  end
end
