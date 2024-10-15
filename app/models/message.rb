class Message < ApplicationRecord
  validates :channel_id, :user_id, presence: true
  validates :ts, presence: true, numericality: true

  belongs_to :channel
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  before_save :set_posted_timestamps
  after_save :expire_cache

  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  paginates_per 50

  default_scope { order(posted_at: :asc) }

  def self.first_date
    minimum(:posted_on)
  end

  def index_by_date
    channel
      .messages_posted_on(self.posted_on).pluck(:posted_at)
      .bsearch_index { |time| time >= posted_at } + 1
  end

  def page_by_date(per_page = self.class.default_per_page)
    (index_by_date.to_f / per_page).ceil
  end

  private

  def set_posted_timestamps
    # times are in local server time
    # set in config/application.rb, see "config.time_zone ="
    self.posted_at = Time.zone.at(ts)
    self.posted_on = posted_at.to_date
  end

  def expire_cache
    Rails.cache.delete_multi(
      %W[
        #{channel.cache_key_with_version}/message_dates_with_counts
        #{channel.cache_key_with_version}/message_counts_by_date
        #{channel.cache_key_with_version}/messages_posted_on/#{posted_on}
      ]
    )

    unless channel.message_dates.include?(posted_on)
      Rails.cache.delete("#{channel.cache_key_with_version}/message_dates")
    end

    if posted_at > channel.time_of_latest_message
      Rails.cache.delete("#{channel.cache_key_with_version}/time_of_latest_message")
    end

    if posted_on < channel.date_of_oldest_message
      Rails.cache.delete("#{channel.cache_key_with_version}/date_of_oldest_message")
    end
  end
end
