require_relative 'slack_client'

class SlackUser
  attr_reader :user_id, :display_name, :tz_offset

  def initialize(user_id)
    @user_id = user_id
    # initialize Slack client
    c = SlackClient.new
    # fetch user info
    u = c.users_info(user: user_id).user
    @display_name = u.profile.display_name
    @tz_offset = u.tz_offset
  end
end
