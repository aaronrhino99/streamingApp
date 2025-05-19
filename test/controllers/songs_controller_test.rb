require "test_helper"

class SongsControllerTest < ActionDispatch::IntegrationTest
  test "should get indec" do
    get songs_indec_url
    assert_response :success
  end
end
