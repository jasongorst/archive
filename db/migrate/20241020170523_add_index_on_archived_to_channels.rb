class AddIndexOnArchivedToChannels < ActiveRecord::Migration[7.2]
  def change
    add_index :channels, :archived
  end
end
