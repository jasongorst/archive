class Message < ApplicationRecord
  validates :channel_id, :user_id, presence: true
  validates :ts, presence: true, numericality: true

  belongs_to :channel
  belongs_to :user
  has_many :attachments

  before_save :set_posted_at_and_posted_on
  after_save :expire_cache_keys

  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  paginates_per 50

  private

  def set_posted_at_and_posted_on
    # times are in local server time
    # set in config/application.rb, see "config.time_zone ="
    self.posted_at = Time.zone.at(ts)
    self.posted_on = posted_at.to_date
  end

  def expire_cache_keys
    Rails.cache.delete_multi(
      %W[
        channels_with_messages
        channels_with_times
        dates_with_counts_in_channel_#{self.channel.id}
        dates_with_messages_in_channel_#{self.channel.id}
        messages_in_channel_#{self.channel.id}_on_#{self.posted_on}
      ]
    )
  end
end
