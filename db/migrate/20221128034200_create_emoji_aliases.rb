class CreateEmojiAliases < ActiveRecord::Migration[7.0]
  def change
    create_table :emoji_aliases do |t|
      t.string :name
      t.string :alias_for

      t.timestamps
    end
    add_index :emoji_aliases, :name
  end
end
