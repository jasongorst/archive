require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get auth_index_url
    assert_response :success
  end

  test "should get confirm" do
    get auth_confirm_url
    assert_response :success
  end
end
