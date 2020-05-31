class Message < ApplicationRecord
  paginates_per 20

  validates :channel_id, :user_id, presence: true

  belongs_to :channel
  belongs_to :user

  def date
    Time.at(ts).to_date.iso8601
  end

  after_save ThinkingSphinx::RealTime.callback_for(:message)
end
