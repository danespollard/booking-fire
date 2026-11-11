require "test_helper"

class AvailabilityBlocksControllerTest < ActionDispatch::IntegrationTest
  test "create adds a block for the date" do
    sign_in users(:one)
    assert_difference "AvailabilityBlock.count", 1 do
      post availability_blocks_path, params: { availability_block: { date: "2026-03-01", status: "open", time_label: "evening" } }
    end
    block = users(:one).availability_blocks.find_by(date: "2026-03-01")
    assert block.open?
    assert block.time_label_evening?
    assert_redirected_to month_path("2026-03")
  end

  test "create on a date that already has a block updates it" do
    sign_in users(:one)
    block = availability_blocks(:open_block)
    assert_no_difference "AvailabilityBlock.count" do
      post availability_blocks_path, params: { availability_block: { date: block.date.to_s, status: "hold" } }, as: :turbo_stream
    end
    assert block.reload.hold?
  end

  test "create responds with turbo stream" do
    sign_in users(:one)
    post availability_blocks_path, params: { availability_block: { date: "2026-03-01", status: "open" } }, as: :turbo_stream
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "target=\"day-2026-03-01\""
    assert_includes response.body, "target=\"openings\""
  end

  test "unauthenticated request redirects to login" do
    post availability_blocks_path, params: { availability_block: { date: "2026-03-01", status: "open" } }
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

  test "destroy removes the block and clears the day" do
    sign_in users(:one)
    block = availability_blocks(:open_block)

    assert_difference "AvailabilityBlock.count", -1 do
      delete availability_block_path(block), as: :turbo_stream
    end

    assert_response :success
    assert_includes response.body, "target=\"day-#{block.date}\""
    assert_includes response.body, "action=\"/availability_blocks\""
  end

  test "cannot change another user's block" do
    sign_in users(:one)
    patch availability_block_path(availability_blocks(:two)), params: { availability_block: { status: "open" } }
    assert_response :not_found
  end
end
