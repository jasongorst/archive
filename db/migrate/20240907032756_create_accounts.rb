class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :email, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.boolean :admin, default: false, null: false
      t.references :user, null: true, foreign_key: false

      t.timestamps
    end

    add_index :accounts, :email
    add_index :accounts, :confirmation_token, unique: true
    add_index :accounts, :remember_token, unique: true
  end
end
