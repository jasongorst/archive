class CreateAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :attachments do |t|
      t.string :name
      t.string :url
      t.belongs_to :message, null: false, foreign_key: true

      t.timestamps
    end
  end
end
