require "test_helper"

class CentroControllerTest < ActionDispatch::IntegrationTest
  test "should get comienzo" do
    get centro_comienzo_url
    assert_response :success
  end
end
