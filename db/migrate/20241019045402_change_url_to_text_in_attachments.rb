class ChangeUrlToTextInAttachments < ActiveRecord::Migration[7.2]
  def change
    change_column :attachments, :url, :text, null: false
  end
end
