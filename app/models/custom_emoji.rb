class CustomEmoji < ApplicationRecord
  has_one_attached :emoji

  validates :name, presence: true
  validates :name, uniqueness: true
end
