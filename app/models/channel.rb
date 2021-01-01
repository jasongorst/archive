class Channel < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  validates :name, :slack_channel, presence: true
  validates :name, :slack_channel, uniqueness: true

  has_many :messages, -> { order(posted_at: :asc) }
end
