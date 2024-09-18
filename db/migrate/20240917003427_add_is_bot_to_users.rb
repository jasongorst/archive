class AddIsBotToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_bot, :boolean, null: false, default: false
  end
end
