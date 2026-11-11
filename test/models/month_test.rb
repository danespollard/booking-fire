require "test_helper"

class MonthTest < ActiveSupport::TestCase
  test "finds a month from its param" do
    month = Month.find("2026-02")
    assert_equal Date.new(2026, 2, 1), month.first_day
    assert_equal Date.new(2026, 2, 28), month.last_day
    assert_equal "2026-02", month.to_param
    assert_equal "February 2026", month.name
  end

  test "rejects params that are not a month" do
    [ "2026-13", "2026-02-01", "february", nil ].each do |param|
      assert_raises(ActiveRecord::RecordNotFound) { Month.find(param) }
    end
  end

  test "steps across year boundaries" do
    assert_equal Month.find("2027-01"), Month.find("2026-12").next
    assert_equal Month.find("2025-12"), Month.find("2026-01").previous
  end

  test "weeks run Sunday to Saturday and cover the whole month" do
    weeks = Month.find("2026-11").weeks
    assert weeks.all? { |week| week.size == 7 && week.first.sunday? }
    assert_includes weeks.flatten, Date.new(2026, 11, 1)
    assert_includes weeks.flatten, Date.new(2026, 11, 30)
  end

  test "knows which dates it includes" do
    month = Month.find("2026-02")
    assert month.include?(Date.new(2026, 2, 28))
    assert_not month.include?(Date.new(2026, 3, 1))
  end
end
