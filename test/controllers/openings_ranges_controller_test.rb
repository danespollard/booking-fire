require "test_helper"

class OpeningsRangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "saves the choice and re-renders the openings" do
    patch openings_range_path, params: { month: "2026-02-01", user: { openings_range: "next_30" } }, as: :turbo_stream
    assert_response :success
    assert_equal "next_30", users(:one).reload.openings_range
    assert_includes response.body, %(turbo-stream action="replace" target="openings")
  end

  test "a bad custom range shows the error and keeps the old choice" do
    patch openings_range_path, params: { user: { openings_range: "custom", openings_from: "2026-12-10", openings_to: "2026-12-01" } }, as: :turbo_stream
    assert_response :success
    assert_includes response.body, "must be on or after the start date"
    assert_equal "month", users(:one).reload.openings_range
  end

  test "requires sign in" do
    delete session_path
    patch openings_range_path, params: { user: { openings_range: "next_30" } }
    assert_redirected_to new_session_path
  end
end
