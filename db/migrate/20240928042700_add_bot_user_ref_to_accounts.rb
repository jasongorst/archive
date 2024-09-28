class AddBotUserRefToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_reference :accounts, :bot_user, null: true, foreign_key: false
  end
end
