class DropAccountFromBotUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :bot_users, :account_id
  end
end
