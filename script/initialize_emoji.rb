begin
  # add custom emoji
  CustomEmoji.all.each do |emoji|
    Emoji.create(emoji.name) do |char|
      char.image_filename = Rails.application.routes.url_helpers
                                 .rails_blob_path(
                                   emoji.emoji.variant(resize_and_pad: [16, 16, alpha: true]).processed,
                                   only_path: true
                                 )
    end
  end

  # add emoji aliases
  EmojiAlias.all.each do |emoji_alias|
    emoji = Emoji.find_by_alias(emoji_alias.alias_for)
    Emoji.edit_emoji(emoji) do |char|
      char.add_alias emoji_alias.name
    end
  end
end
