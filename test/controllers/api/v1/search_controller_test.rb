require "test_helper"

class Api::V1::SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get youtube_search" do
    get api_v1_search_youtube_search_url
    assert_response :success
  end
end
