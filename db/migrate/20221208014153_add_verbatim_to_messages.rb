class AddVerbatimToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :verbatim, :text
  end
end
