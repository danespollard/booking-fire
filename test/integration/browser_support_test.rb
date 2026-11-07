require "test_helper"

class BrowserSupportTest < ActionDispatch::IntegrationTest
  SUPPORTED = {
    "Safari 16.4 on iPhone" => "Mozilla/5.0 (iPhone; CPU iPhone OS 16_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Mobile/15E148 Safari/604.1",
    "Safari 17 on Mac" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15",
    "Chrome 111" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36",
    "Firefox 128" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"
  }.freeze

  UNSUPPORTED = {
    "Safari 15.6 on iPhone" => "Mozilla/5.0 (iPhone; CPU iPhone OS 15_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6 Mobile/15E148 Safari/604.1",
    "Chrome 110" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
    "Firefox 115" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:115.0) Gecko/20100101 Firefox/115.0"
  }.freeze

  SUPPORTED.each do |name, user_agent|
    test "allows #{name}" do
      get new_session_path, headers: { "User-Agent" => user_agent }
      assert_response :success
    end
  end

  UNSUPPORTED.each do |name, user_agent|
    test "turns away #{name}" do
      get new_session_path, headers: { "User-Agent" => user_agent }
      assert_response :not_acceptable
    end
  end
end
