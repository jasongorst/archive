class Message < ApplicationRecord
  paginates_per 50

  validates :channel_id, :user_id, presence: true

  belongs_to :channel
  belongs_to :user
  has_many :attachments

  def date
    Time.at(ts).to_date
  end

  after_save ThinkingSphinx::RealTime.callback_for(:message)
end
