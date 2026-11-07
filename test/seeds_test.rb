require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_seed
    @user = User.find_by!(email_address: "test@example.com")
  end

  test "creates a demo account with templates" do
    assert @user.authenticate("password")
    assert_equal [ "Short", "Full List", "By Weekday", "Wedding Planner" ], @user.templates.ordered.pluck(:name)
  end

  test "fills the calendar around today with every status" do
    blocks = @user.availability_blocks
    assert blocks.where(date: Date.current.beginning_of_month..Date.current.end_of_month).exists?
    assert_equal %w[booked hold open], blocks.distinct.pluck(:status).sort
    assert blocks.where.not(client_name: nil).exists?
  end

  test "only marks future dates as open or on hold" do
    assert_not @user.availability_blocks.where(date: ...Date.current, status: [ :open, :hold ]).exists?
  end

  test "is safe to run again" do
    assert_no_difference -> { @user.templates.count } do
      Rails.application.load_seed
    end
    assert_equal @user.availability_blocks.count, @user.availability_blocks.distinct.count(:date)
  end
end
