require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "authenticates with correct password" do
    user = users(:one)
    assert user.authenticate("password")
  end

  test "rejects wrong password" do
    user = users(:one)
    assert_not user.authenticate("wrong")
  end

  test "normalizes email by stripping whitespace and downcasing" do
    user = User.create!(email_address: "  FOO@BAR.COM  ", password: "password123")
    assert_equal "foo@bar.com", user.email_address
  end

  test "destroying user cascades to sessions" do
    user = users(:one)
    user.sessions.create!(user_agent: "test", ip_address: "127.0.0.1")
    assert_difference "Session.count", -user.sessions.count do
      user.destroy
    end
  end

  test "destroying user cascades to availability_blocks" do
    user = users(:one)
    assert user.availability_blocks.any?
    assert_difference "AvailabilityBlock.count", -user.availability_blocks.count do
      user.destroy
    end
  end
end
