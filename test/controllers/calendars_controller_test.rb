require "test_helper"

class CalendarsControllerTest < ActionDispatch::IntegrationTest
  test "GET /calendar authenticated renders successfully" do
    sign_in users(:one)
    get calendar_path
    assert_response :success
  end

  test "GET /calendar with date param scopes to that month" do
    sign_in users(:one)
    get calendar_path(date: "2026-02-01")
    assert_response :success
  end

  test "GET /calendar unauthenticated redirects to login" do
    get calendar_path
    assert_redirected_to new_session_path
  end
end
