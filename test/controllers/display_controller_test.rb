require 'test_helper'

class DisplayControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get display_index_url
    assert_response :success
  end

  test "should get show" do
    get display_show_url
    assert_response :success
  end

end
