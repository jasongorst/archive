class AddDeletedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :deleted, :boolean, null: false, default: false
  end
end
