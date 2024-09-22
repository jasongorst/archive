class Channel < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  validates :name, :slack_channel, presence: true
  validates :name, :slack_channel, uniqueness: true

  has_many :messages, -> { order(posted_at: :asc) }

  scope :with_messages, -> { where.associated(:messages).distinct.order(name: :asc) }

  def message_dates
    messages.group(:posted_on).pluck(:posted_on)
  end

  def message_dates_with_counts
    messages.reorder(posted_on: :desc).group(:posted_on).count
  end

  def time_of_latest_message
    messages.maximum(:posted_at)
  end

  def date_of_oldest_message
    messages.minimum(:posted_on)
  end

  def messages_posted_on(date)
    messages.where(posted_on: date)
  end

  def next_date_after(date)
    dates = message_dates
    index = dates.bsearch_index { |d| d >= date }

    if index.nil? || index == (dates.length - 1)
      nil
    else
      dates[index + 1]
    end
  end

  def previous_date_before(date)
    dates = message_dates
    index = dates.bsearch_index { |d| d >= date }

    if index.zero?
      nil
    else
      dates[index - 1]
    end
  end
end
