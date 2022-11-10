class User < ApplicationRecord
  validates :slack_user, :display_name, presence: true
  validates :slack_user, :display_name, uniqueness: true

  has_many :messages, -> { order(posted_at: :asc) }
end
