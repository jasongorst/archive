class RemoveHasSignedInFromAccounts < ActiveRecord::Migration[7.1]
  def change
    remove_column :accounts, :has_signed_in, :boolean, default: false
  end
end
