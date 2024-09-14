class CreateBotUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :bot_users do |t|
      t.string :slack_user
      t.string :display_name
      t.string :user_access_token
      t.string :user_oauth_scope
      t.boolean :active, default: false
      t.references :team, null: false, foreign_key: true
      t.references :account, null: true, foreign_key: true

      t.timestamps
    end

    add_index :bot_users, :slack_user, unique: true
  end
end
