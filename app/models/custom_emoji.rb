class CustomEmoji < ApplicationRecord
  has_one_attached :emoji

  validates :name, :url, presence: true
  validates :name, uniqueness: true
end
