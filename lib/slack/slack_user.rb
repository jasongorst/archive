require "slack/slack_client"

class SlackUser
  attr_reader :user_id, :display_name, :tz_offset

  def initialize(user_id)
    @user_id = user_id
    # initialize Slack client
    sc = SlackClient.new
    # fetch user info
    u = sc.users_info(user: user_id).user

    # set @display_name to first present display_name, real_name, or default
    if u.profile.display_name.present?
      @display_name = u.profile.display_name
    elsif u.profile.real_name.present?
      @display_name = u.profile.real_name
    else
      @display_name = "Unknown User"
    end

    @tz_offset = u.tz_offset
  end
end
