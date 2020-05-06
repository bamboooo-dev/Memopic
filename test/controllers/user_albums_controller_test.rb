require 'test_helper'

class UserAlbumsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_albums_create_url
    assert_response :success
  end

end
