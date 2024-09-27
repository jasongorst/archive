class DropAdminUsersAgain < ActiveRecord::Migration[7.1]
  def up
    remove_index :admin_users, :email
    remove_index :admin_users, :remember_token
    drop_table :admin_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration cannot be reverted."
  end
end
