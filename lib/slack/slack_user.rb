require "slack/slack_client"

class SlackUser
  attr_reader :user_id, :display_name, :is_bot, :deleted

  def initialize(user_id)
    @user_id = user_id
    # initialize Slack client
    sc = SlackClient.new

    # fetch user info
    begin
      u = sc.users_info(user: @user_id).user
    rescue Slack::Web::Api::Errors::UserNotFound
      @display_name = "Unknown User <#{@user_id}>"
      @is_bot = false
      @deleted = true
    else
      # set @display_name to first present display_name, real_name, or default
      @display_name = if u.profile.display_name.present?
                        u.profile.display_name
                      elsif u.profile.real_name.present?
                        u.profile.real_name
                      else
                        @user_id
                      end

      @is_bot = u.is_bot
      @deleted = u.deleted
    end
  end
end
