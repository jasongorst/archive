class Message < ApplicationRecord
  paginates_per 50

  validates :channel_id, :user_id, presence: true
  validates :ts, presence: true, numericality: true

  belongs_to :channel
  belongs_to :user
  has_many :attachments

  before_save :set_posted_at_and_posted_on
  after_save ThinkingSphinx::RealTime.callback_for(:message)

  private

  def set_posted_at_and_posted_on
    # times are in local server time (America/Chicago)
    local_offset = Time.now.localtime.utc_offset
    self.posted_at = Time.at(ts + local_offset)
    self.posted_on = posted_at.to_date
  end
end
