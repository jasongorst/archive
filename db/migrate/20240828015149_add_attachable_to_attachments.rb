class AddAttachableToAttachments < ActiveRecord::Migration[7.1]
  def change
    add_reference :attachments, :attachable, polymorphic: true, null: false

    reversible do |dir|
      dir.up do
        Attachment.update_all "attachable_id = message_id, attachable_type = 'Message'"
      end

      dir.down do
        Attachment.update_all "message_id = attachable_id"
      end

      remove_reference :attachments, :message, index: true, foreign_key: true
    end
  end
end
