require "test_helper"

class OpeningsControllerTest < ActionDispatch::IntegrationTest
  test "GET /openings.text authenticated returns plain text" do
    sign_in users(:one)
    get openings_path(format: :text)
    assert_response :success
    assert_equal "text/plain", response.media_type
  end

  test "GET /openings authenticated HTML redirects to calendar" do
    sign_in users(:one)
    get openings_path
    assert_redirected_to calendar_path
  end

  test "GET /openings unauthenticated redirects to login" do
    get openings_path
    assert_redirected_to new_session_path
  end
end
