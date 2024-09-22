class AddHasSignedInToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :has_signed_in, :boolean, default: false
  end
end
