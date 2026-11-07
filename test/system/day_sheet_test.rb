require "application_system_test_case"

class DaySheetTest < ApplicationSystemTestCase
  setup do
    @day = Date.current.beginning_of_month + 14
    visit new_session_path
    fill_in "email_address", with: users(:one).email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    assert_selector ".calendar-day-cell"
  end

  test "close button closes the day sheet" do
    open_day_sheet
    find("#day-#{@day} dialog button[aria-label='Close']").click
    assert_no_selector "dialog[open]"
  end

  test "clicking the backdrop closes the day sheet" do
    open_day_sheet
    page.execute_script("arguments[0].click()", find("#day-#{@day} dialog"))
    assert_no_selector "dialog[open]"
  end

  test "escape closes the day sheet" do
    open_day_sheet
    find("#day-#{@day} dialog").send_keys(:escape)
    assert_no_selector "dialog[open]"
  end

  test "saving from the day sheet marks the day" do
    open_day_sheet
    within("#day-#{@day} dialog") { click_on "Save" }
    assert_selector "#day-#{@day} .calendar-day-cell.bg-emerald-100"
  end

  test "a rejected save shows the error page instead of Content missing" do
    open_day_sheet
    page.driver.browser.execute_cdp(
      "Network.setUserAgentOverride",
      userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 15_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6 Mobile/15E148 Safari/604.1"
    )
    within("#day-#{@day} dialog") { click_on "Save" }
    assert_text "Your browser is not supported"
    assert_no_text "Content missing"
  ensure
    page.driver.browser.execute_cdp("Network.setUserAgentOverride", userAgent: "")
  end

  private

  def open_day_sheet
    find("#day-#{@day} .calendar-day-cell").click
    assert_selector "#day-#{@day} dialog[open]"
  end
end
