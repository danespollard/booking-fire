require "test_helper"

class AvailabilityBlockTest < ActiveSupport::TestCase
  test "requires date" do
    block = AvailabilityBlock.new(user: users(:one), status: :open, date: nil)
    assert_not block.valid?
    assert block.errors[:date].any?
  end

  test "requires status" do
    block = AvailabilityBlock.new(user: users(:one), date: "2026-03-01", status: nil)
    assert_not block.valid?
    assert block.errors[:status].any?
  end

  test "enforces uniqueness of date scoped to user" do
    block = AvailabilityBlock.new(user: users(:one), date: availability_blocks(:one).date, status: :open)
    assert_not block.valid?
    assert block.errors[:date].any?
  end

  test "different users can have blocks on the same date" do
    assert_equal availability_blocks(:one).date, availability_blocks(:two).date
    assert_not_equal availability_blocks(:one).user, availability_blocks(:two).user
  end

  test "open? returns true for open status" do
    assert availability_blocks(:open_block).open?
  end

  test "booked? returns true for booked status" do
    assert availability_blocks(:one).booked?
  end

  test "open scope returns only open blocks" do
    open_blocks = AvailabilityBlock.open
    open_blocks.each { |b| assert b.open? }
  end

  test "booked scope returns only booked blocks" do
    booked_blocks = AvailabilityBlock.booked
    booked_blocks.each { |b| assert b.booked? }
  end
end
