class Message < ApplicationRecord
  include ThinkingSphinx::Scopes

  validates :channel_id, :user_id, presence: true
  validates :ts, presence: true, numericality: true

  belongs_to :channel
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  before_save :set_posted_timestamps

  after_save :set_last_message_at
  after_save :delete_caches_for_new_message

  before_destroy :update_last_message_at
  before_destroy :delete_caches_for_destroyed_message

  ThinkingSphinx::Callbacks.append(self, behaviours: [ :real_time ])

  paginates_per 50

  default_scope { order(posted_at: :asc) }

  sphinx_scope :with_includes do
    { sql: { include: [ :channel, :user, :attachments ] } }
  end

  default_sphinx_scope :with_includes

  def self.earliest_date
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

  def set_last_message_at
    if channel.last_message_at.nil? || posted_at > channel.last_message_at
      channel.update(last_message_at: posted_at)
    end
  end

  def update_last_message_at
    if posted_at == channel.last_message_at
      channel.update(last_message_at: channel.messages.maximum(:posted_at))
    end
  end

  def delete_caches_for_new_message
    delete_caches_for_posted_on

    # delete message_dates cache if it doesn't contain posted_on
    Rails.cache.delete("#{channel.cache_key_with_version}/message_dates") unless posted_on.in?(channel.message_dates)

    # delete date_of_oldest_message cache if posted_on is before then
    Rails.cache.delete("#{channel.cache_key_with_version}/date_of_oldest_message") if posted_on < channel.date_of_oldest_message
  end

  def delete_caches_for_destroyed_message
    delete_caches_for_posted_on

    # delete message_dates cache if this message is the only message posted on that date in this channel
    if channel.messages_posted_on(posted_on).size == 1
      Rails.cache.delete("#{channel.cache_key_with_version}/message_dates")

      # also delete date_of_oldest_message cache if this message is the oldest
      if posted_on == channel.date_of_oldest_message
        Rails.cache.delete("#{channel.cache_key_with_version}/date_of_oldest_message")
      end
    end
  end

  def delete_caches_for_posted_on
    Rails.cache.delete_multi(
      %W[
        #{channel.cache_key_with_version}/message_counts_by_date
        #{channel.cache_key_with_version}/messages_posted_on/#{posted_on}
      ]
    )
  end
end
