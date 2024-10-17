class AddArchivedToChannels < ActiveRecord::Migration[7.2]
  def change
    add_column :channels, :archived, :boolean, default: false, null: false
    Channel.update_all(archived: false)
  end
end
