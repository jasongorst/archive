class AlterAttachmentsForeignKeyDeleteAction < ActiveRecord::Migration[7.0]
  def change
    change_table :attachments do |t|
      t.remove_foreign_key :messages, if_exists: true
      t.foreign_key :messages, on_delete: :cascade
    end
  end
end
