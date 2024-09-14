require "test_helper"

class BotUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bot_users_index_url
    assert_response :success
  end
end
