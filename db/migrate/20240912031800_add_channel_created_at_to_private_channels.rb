class AddChannelCreatedAtToPrivateChannels < ActiveRecord::Migration[7.1]
  def change
    add_column :private_channels, :channel_created_at, :datetime
  end
end
