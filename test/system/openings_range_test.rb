require "application_system_test_case"

class OpeningsRangeTest < ApplicationSystemTestCase
  setup do
    users(:one).availability_blocks.create!(date: Date.current + 3, status: :open)
    users(:one).availability_blocks.create!(date: Date.current + 40, status: :open)
    visit new_session_path
    fill_in "email_address", with: users(:one).email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    assert_selector ".calendar-day-cell"
  end

  test "choosing a preset changes the message and is remembered" do
    near = (Date.current + 3).strftime("%a %-m/%-d")
    far = (Date.current + 40).strftime("%a %-m/%-d")

    select "Next 60 days", from: "Dates"
    within("#openings") { assert_text near }
    within("#openings") { assert_text far }

    select "Next 2 weeks", from: "Dates"
    within("#openings") { assert_no_text far }
    within("#openings") { assert_text near }

    visit root_path
    assert_select "Dates", selected: "Next 2 weeks"
    within("#openings") { assert_no_text far }
  end

  test "custom dates appear when chosen" do
    select "Custom dates", from: "Dates"
    assert_field "From", with: Date.current.iso8601
    assert_field "To", with: (Date.current + 29).iso8601
  end
end
