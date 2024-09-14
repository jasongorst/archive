class CreatePrivateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :private_messages do |t|
      t.text :text
      t.text :verbatim
      t.decimal :ts, precision: 20, scale: 6
      t.belongs_to :private_channel, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.date :posted_on
      t.datetime :posted_at

      t.timestamps
    end

    add_index :private_messages, :ts
    add_index :private_messages, :posted_at
    add_index :private_messages, :posted_on
  end
end
