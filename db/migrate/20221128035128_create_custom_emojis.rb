class CreateCustomEmojis < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_emojis do |t|
      t.string :name

      t.timestamps
    end
    add_index :custom_emojis, :name
  end
end
