class AddLastMessageAtToPrivateChannels < ActiveRecord::Migration[7.2]
  def change
    add_column :private_channels, :last_message_at, :datetime

    PrivateChannel.all.each do |private_channel|
      private_channel.update(last_message_at: private_channel.private_messages.maximum(:posted_at))
    end
  end
end
