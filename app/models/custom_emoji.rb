class CustomEmoji < ApplicationRecord
  validates :name, :url, presence: true
  validates :name, uniqueness: true

  has_one_attached :emoji do |attachable|
    attachable.variant :emoji, resize_and_pad: [16, 16, alpha: true], preprocessed: true
  end
end
