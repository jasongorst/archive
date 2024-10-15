class DmController < ApplicationController
  layout "main"
  before_action :require_login
  before_action :require_user

  def index
    @private_channels = current_account.user.private_channels.with_messages
  end

  def show
    @private_channel = current_account.user.private_channels.find(params[:private_channel_id])
    @private_message_counts_by_date = @private_channel.private_message_counts_by_date
  end

  def by_date
    @private_channel = current_account.user.private_channels.find(params[:private_channel_id])
    @date = params[:date].to_date
    @private_messages = @private_channel.private_messages_posted_on(@date).page(params[:page])
  end
end
