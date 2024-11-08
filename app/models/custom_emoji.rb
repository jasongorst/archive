class CustomEmoji < ApplicationRecord
  validates :name, :url, presence: true
  validates :name, uniqueness: true

  has_one_attached :emoji do |attachable|
    attachable.variant :emoji, resize_to_fit: [ 16, 16, size: :down ], preprocessed: true
    attachable.variant :emoji_1x, resize_to_fit: [ 16, 16, size: :down ], preprocessed: true
    attachable.variant :emoji_2x, resize_to_fit: [ 32, 32, size: :down ], preprocessed: true
    attachable.variant :emoji_3x, resize_to_fit: [ 48, 48, size: :down ], preprocessed: true
    attachable.variant :emoji_lg_1x, resize_to_fit: [ 32, 32, size: :down ], preprocessed: true
    attachable.variant :emoji_lg_2x, resize_to_fit: [ 64, 64, size: :down ], preprocessed: true
    attachable.variant :emoji_lg_3x, resize_to_fit: [ 96, 96, size: :down ], preprocessed: true
  end

  def self.create_all
    all.each(&:create_emoji)
  end

  def image_path(variant = :emoji)
    Rails.application.routes.url_helpers
         .rails_blob_path(
           emoji.variant(variant).processed,
           only_path: true
         )
  end

  def emoji_image_tag(variant: nil, size: "16x16", densities: %w[1x 2x 3x], **kwargs)
    variant_base = if variant.nil?
                     ""
                   else
                     "_#{variant}"
                   end

    srcset = densities.map { |density| [ image_path("emoji#{variant_base}_#{density}".to_sym), density ] }
    class_name = kwargs.delete(:class)

    # pass through additional keyword args to image_tag
    ActionController::Base.helpers
                          .image_tag(
                            image_path("emoji#{variant_base}_1x".to_sym),
                            srcset: srcset,
                            size: size,
                            class: "emoji #{class_name}",
                            **kwargs
                          )
  end

  def large_emoji_image_tag(**kwargs)
    class_name = kwargs.delete(:class)

    # pass through additional keyword args to emoji_image_tag
    emoji_image_tag(
      variant: "lg",
      size: "32x32",
      class: "emoji-lg #{class_name}",
      **kwargs
    )
  end

  def create_emoji
    Emoji.create(name) do |char|
      char.image_filename = image_path
    end
  end
end
