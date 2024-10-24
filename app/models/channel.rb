class Channel < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  validates :name, :slack_channel, presence: true
  validates :name, :slack_channel, uniqueness: true

  has_many :messages, -> { order(posted_at: :asc) }, dependent: :destroy

  default_scope { order(name: :asc) }
  scope :unarchived, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  scope :with_messages, -> { where.associated(:messages).distinct }

  def message_dates
    Rails.cache.fetch("#{cache_key_with_version}/message_dates") do
      messages.group(:posted_on).pluck(:posted_on)
    end
  end

  def message_dates_with_counts
    messages.reorder(posted_on: :desc).group(:posted_on).count
  end

  def message_counts_by_date
    Rails.cache.fetch("#{cache_key_with_version}/message_counts_by_date") do
      message_dates_with_counts
        .group_by { |date, _| date.year }
        .transform_values { |counts| counts.group_by { |date, _| date.month } }
        .transform_values { |month| month.transform_values(&:to_h) }
    end
  end

  def time_of_latest_message
    Rails.cache.fetch("#{cache_key_with_version}/time_of_latest_message") do
      messages.maximum(:posted_at)
    end
  end

  def date_of_oldest_message
    Rails.cache.fetch("#{cache_key_with_version}/date_of_oldest_message") do
      messages.minimum(:posted_on)
    end
  end

  def messages_posted_on(date)
    Rails.cache.fetch("#{cache_key_with_version}/messages_posted_on/#{date}") do
      messages.includes(:user, :attachments).where(posted_on: date)
    end
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
end
