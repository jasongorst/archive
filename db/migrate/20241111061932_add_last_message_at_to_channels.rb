class AddLastMessageAtToChannels < ActiveRecord::Migration[7.2]
  def change
    add_column :channels, :last_message_at, :datetime

    Channel.all.each do |channel|
      channel.update(last_message_at: channel.messages.maximum(:posted_at))
    end
  end
end
