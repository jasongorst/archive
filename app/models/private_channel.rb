class PrivateChannel < ApplicationRecord
  validates :slack_channel, presence: true
  validates :slack_channel, uniqueness: true

  has_and_belongs_to_many :users, dependent: :destroy
  has_many :private_messages, -> { order(posted_at: :asc) }, dependent: :destroy

  default_scope { order(channel_created_at: :desc) }
  scope :unarchived, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  scope :with_messages, -> { where.associated(:private_messages).distinct.reorder(last_message_at: :desc) }

  def user_names
    users.pluck(:display_name).to_sentence
  end

  def display_name(current_user = nil)
    if name.present?
      "\##{name}"
    elsif current_user.present?
      other_users_as_sentence(current_user)
    else
      user_names
    end
  end

  def other_users_as_sentence(current_user)
    if users.count == 1 && users.first == current_user
      "myself"
    else
      users.excluding(current_user).pluck(:display_name).to_sentence
    end
  end

  def message_dates
    Rails.cache.fetch("#{cache_key_with_version}/message_dates") do
      private_messages.group(:posted_on).pluck(:posted_on)
    end
  end

  def private_message_dates_with_counts
    private_messages.reorder(posted_on: :desc).group(:posted_on).count
  end

  def private_message_counts_by_date
    Rails.cache.fetch("#{cache_key_with_version}/private_message_counts_by_date") do
      private_message_dates_with_counts
        .group_by { |date, _| date.year }
        .transform_values { |counts| counts.group_by { |date, _| date.month } }
        .transform_values { |month| month.transform_values(&:to_h) }
    end
  end

  def date_of_oldest_message
    Rails.cache.fetch("#{cache_key_with_version}/date_of_oldest_message") do
      private_messages.minimum(:posted_on)
    end
  end

  def private_messages_posted_on(date)
    Rails.cache.fetch("#{cache_key_with_version}/private_messages_posted_on/#{date}") do
      private_messages.includes(:user, :attachments).where(posted_on: date)
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
