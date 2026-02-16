require "test_helper"

class AvailabilityBlocksControllerTest < ActionDispatch::IntegrationTest
  test "toggle with no existing block creates open block" do
    sign_in users(:one)
    assert_difference "AvailabilityBlock.count", 1 do
      post availability_blocks_toggle_path, params: { date: "2026-03-01" }
    end
    block = users(:one).availability_blocks.find_by(date: "2026-03-01")
    assert block.open?
  end

  test "toggle on open block updates to booked" do
    sign_in users(:one)
    open_block = availability_blocks(:open_block)
    assert open_block.open?
    assert_no_difference "AvailabilityBlock.count" do
      post availability_blocks_toggle_path, params: { date: open_block.date.to_s }
    end
    open_block.reload
    assert open_block.booked?
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
end
