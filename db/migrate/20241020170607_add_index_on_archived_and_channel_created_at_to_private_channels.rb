class AddIndexOnArchivedAndChannelCreatedAtToPrivateChannels < ActiveRecord::Migration[7.2]
  def change
    add_index :private_channels, :archived
    add_index :private_channels, :channel_created_at
  end
end
