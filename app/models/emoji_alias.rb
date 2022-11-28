class EmojiAlias < ApplicationRecord
  validates :name, :alias_for, presence: true
  validates :name, uniqueness: true
end
