require "test_helper"

class AvailabilityBlocksControllerTest < ActionDispatch::IntegrationTest
  test "toggle with no existing block creates open block" do
    sign_in users(:one)
    assert_difference "AvailabilityBlock.count", 1 do
      post availability_blocks_toggle_path, params: { date: "2026-03-01", availability_block: { status: "open", time_label: "evening" } }
    end
    block = users(:one).availability_blocks.find_by(date: "2026-03-01")
    assert block.open?
    assert block.time_label_evening?
  end

  test "toggle on booked block destroys block" do
    sign_in users(:one)
    booked_block = availability_blocks(:one)
    assert booked_block.booked?
    assert_difference "AvailabilityBlock.count", -1 do
      post availability_blocks_toggle_path, params: { date: booked_block.date.to_s }
    end
  end

  test "unauthenticated request redirects to login" do
    post availability_blocks_toggle_path, params: { date: "2026-03-01" }
    assert_redirected_to new_session_path
  end

  test "update responds with turbo stream" do
    sign_in users(:one)
    block = availability_blocks(:open_block)

    patch availability_block_path(block),
      params: { availability_block: { status: "booked" } },
      as: :turbo_stream

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert block.reload.booked?
    assert_includes response.body, "target=\"day-#{block.date}\""
    assert_includes response.body, "target=\"openings\""
  end
end
