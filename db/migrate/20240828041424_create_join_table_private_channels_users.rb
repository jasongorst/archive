class CreateJoinTablePrivateChannelsUsers < ActiveRecord::Migration[7.1]
  def change
    create_join_table :private_channels, :users do |t|
      t.index [ :private_channel_id, :user_id ]
      t.index [ :user_id, :private_channel_id ]
    end
  end
end
