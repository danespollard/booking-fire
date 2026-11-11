require "test_helper"

class MonthsControllerTest < ActionDispatch::IntegrationTest
  test "root shows the current month" do
    sign_in users(:one)
    get root_path
    assert_response :success
    assert_select "h1", Date.current.strftime("%B %Y")
  end

  test "shows the requested month with links to its neighbors" do
    sign_in users(:one)
    get month_path("2026-02")
    assert_response :success
    assert_select "h1", "February 2026"
    assert_select "a[href=?]", month_path("2026-01")
    assert_select "a[href=?]", month_path("2026-03")
    assert_select "#day-2026-02-16"
  end

  test "an impossible month is not found" do
    sign_in users(:one)
    get "/months/2026-13"
    assert_response :not_found
  end

  test "does not create templates" do
    sign_in users(:one)
    assert_no_difference "Template.count" do
      get root_path
    end
  end

  test "unauthenticated redirects to login" do
    get root_path
    assert_redirected_to new_session_path
  end
end
