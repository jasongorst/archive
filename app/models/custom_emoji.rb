class CustomEmoji < ApplicationRecord
  validates :name, :url, presence: true
  validates :name, uniqueness: true

  has_one_attached :emoji do |attachable|
    attachable.variant :emoji, resize_and_pad: [ 16, 16, { alpha: true } ], preprocessed: true
  end

  def self.create_all
    all.each(&:create_emoji)
  end

  def image_path
    Rails.application.routes.url_helpers
         .rails_blob_path(
           emoji.variant(:emoji).processed,
           only_path: true
         )
  end

  def create_emoji
    Emoji.create(name) do |char|
      char.image_filename = image_path
    end
  end
end
