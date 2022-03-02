class DropAdminUsers < ActiveRecord::Migration[6.1]
  def change
    remove_index :admin_users, :reset_password_token
    remove_index :admin_users, :email
    drop_table :admin_users
  end
end
