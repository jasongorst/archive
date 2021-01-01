class AddPostedOnToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :posted_on, :date, null: false
    add_index :messages, :posted_on

    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE messages SET posted_on = DATE(FROM_UNIXTIME(ts))
        SQL
      end
      dir.down do
        # nothing
      end
    end
  end
end
