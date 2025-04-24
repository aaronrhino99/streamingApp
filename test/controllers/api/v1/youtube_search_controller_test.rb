require "test_helper"

class Api::V1::YoutubeSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get api_v1_youtube_search_search_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_youtube_search_show_url
    assert_response :success
  end
end
