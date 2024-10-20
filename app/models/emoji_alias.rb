class EmojiAlias < ApplicationRecord
  validates :name, :alias_for, presence: true
  validates :name, uniqueness: true

  def self.create_all
    # ensure all CustomEmoji have been added to Emoji
    CustomEmoji.create_all

    all.each(&:create_emoji_alias)
  end

  def create_emoji_alias
    emoji = Emoji.find_by_alias(alias_for)
    Emoji.edit_emoji(emoji) { |char| char.add_alias name } if emoji
  end
end
