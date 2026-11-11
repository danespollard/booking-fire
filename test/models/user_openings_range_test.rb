require "test_helper"

class UserOpeningsRangeTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @today = Date.new(2026, 11, 6)
    @month = Date.new(2027, 2, 1)
  end

  test "defaults to the month on the calendar" do
    assert_equal "month", @user.openings_range
    assert_equal Date.new(2027, 2, 1)..Date.new(2027, 2, 28), @user.openings_dates(month: @month, today: @today)
  end

  test "next 2 weeks starts today and covers 14 days" do
    @user.openings_range = "next_14"
    assert_equal @today..Date.new(2026, 11, 19), @user.openings_dates(month: @month, today: @today)
  end

  test "next 30, 60 and 90 days ignore the calendar month" do
    { "next_30" => 30, "next_60" => 60, "next_90" => 90 }.each do |range, days|
      @user.openings_range = range
      dates = @user.openings_dates(month: @month, today: @today)
      assert_equal @today, dates.begin
      assert_equal days, dates.count
    end
  end

  test "custom uses the saved dates" do
    @user.update!(openings_range: "custom", openings_from: "2026-12-01", openings_to: "2027-01-15")
    assert_equal Date.new(2026, 12, 1)..Date.new(2027, 1, 15), @user.reload.openings_dates(month: @month, today: @today)
  end

  test "switching to custom without dates fills in the next 30 days" do
    travel_to @today do
      @user.update!(openings_range: "custom")
      assert_equal @today..Date.new(2026, 12, 5), @user.openings_dates(month: @month)
    end
  end

  test "custom end before start is invalid" do
    @user.assign_attributes(openings_range: "custom", openings_from: "2026-12-10", openings_to: "2026-12-01")
    assert_not @user.valid?
    assert_includes @user.errors[:openings_to], "must be on or after the start date"
  end

  test "custom ranges longer than a year are invalid" do
    @user.assign_attributes(openings_range: "custom", openings_from: "2026-12-01", openings_to: "2027-12-02")
    assert_not @user.valid?
  end

  test "unknown ranges are invalid" do
    @user.openings_range = "forever"
    assert_not @user.valid?
  end
end
