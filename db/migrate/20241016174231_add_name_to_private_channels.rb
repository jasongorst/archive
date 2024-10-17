class AddNameToPrivateChannels < ActiveRecord::Migration[7.2]
  def change
    add_column :private_channels, :name, :string, null: true
  end
end
