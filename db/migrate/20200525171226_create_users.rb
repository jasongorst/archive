class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :slack_user
      t.string :display_name

      t.timestamps
    end
    add_index :users, :slack_user
  end
end
