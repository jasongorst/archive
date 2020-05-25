class Channel < ApplicationRecord
  validates :name, :slack_channel, presence: true
  validates :name, :slack_channel, uniqueness: true

  has_many :messages, -> { order(ts: :asc) }
end
