class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.string :slack_channel
      t.string :name

      t.timestamps
    end
    add_index :channels, :slack_channel
    add_index :channels, :name
  end
end
