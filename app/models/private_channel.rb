class PrivateChannel < ApplicationRecord
  validates :slack_channel, presence: true
  validates :slack_channel, uniqueness: true

  has_and_belongs_to_many :users, dependent: :destroy
  has_many :private_messages, -> { order(posted_at: :asc) }, dependent: :destroy

  default_scope { order(channel_created_at: :desc) }

  scope :with_messages, -> { where.associated(:private_messages).distinct.sort_by { |private_channel| private_channel.time_of_latest_message }.reverse! }

  def message_dates
    private_messages.group(:posted_on).pluck(:posted_on)
  end

  def message_dates_with_counts
    private_messages.reorder(posted_on: :desc).group(:posted_on).count
  end

  def time_of_latest_message
    private_messages.maximum(:posted_at)
  end

  def date_of_oldest_message
    private_messages.minimum(:posted_on)
  end

  def private_messages_posted_on(date)
    private_messages.where(posted_on: date)
  end

  def next_date_after(date)
    index = message_dates.bsearch_index { |d| d >= date }

    if index.nil? || index == (message_dates.length - 1)
      nil
    else
      message_dates[index + 1]
    end
  end

  def previous_date_before(date)
    index = message_dates.bsearch_index { |d| d >= date }

    if index.zero?
      nil
    else
      message_dates[index - 1]
    end
  end

  def other_users_as_sentence(current_user)
    if users.count == 1 && users.first == current_user
      "myself"
    else
      users.excluding(current_user).pluck(:display_name).to_sentence
    end
  end
end
