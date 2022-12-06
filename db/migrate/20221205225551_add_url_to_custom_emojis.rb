class AddUrlToCustomEmojis < ActiveRecord::Migration[7.0]
  def change
    add_column :custom_emojis, :url, :string
  end
end
