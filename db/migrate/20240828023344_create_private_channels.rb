class CreatePrivateChannels < ActiveRecord::Migration[7.1]
  def change
    create_table :private_channels do |t|
      t.string :slack_channel

      t.timestamps
    end

    add_index :private_channels, :slack_channel
  end
end
