class AddArchivedToPrivateChannels < ActiveRecord::Migration[7.2]
  def change
    add_column :private_channels, :archived, :boolean, default: false, null: false
    PrivateChannel.update_all(archived: false)
  end
end
