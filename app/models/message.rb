class Message < ApplicationRecord
  paginates_per 50

  validates :channel_id, :user_id, presence: true

  belongs_to :channel
  belongs_to :user

  after_save ThinkingSphinx::RealTime.callback_for(:message)
end
