require "test_helper"

class OpeningsControllerTest < ActionDispatch::IntegrationTest
  test "GET /openings.text authenticated returns plain text" do
    sign_in users(:one)
    get openings_path(format: :text)
    assert_response :success
    assert_equal "text/plain", response.media_type
  end

  test "GET /openings.text uses the saved range" do
    user = users(:one)
    user.update!(openings_range: "custom", openings_from: "2026-02-17", openings_to: "2026-02-17")
    user.templates.create!(name: "Short", body: "Open: {open_dates}")
    sign_in user
    get openings_path(format: :text)
    assert_equal "Open: Tue 2/17", response.body
  end

  test "GET /openings.text from and to override the saved range" do
    user = users(:one)
    user.templates.create!(name: "Short", body: "Open: {open_dates}")
    sign_in user
    get openings_path(format: :text, from: "2026-02-01", to: "2026-02-28")
    assert_equal "Open: Tue 2/17", response.body
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
