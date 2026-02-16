require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "GET /session/new renders successfully" do
    get new_session_path
    assert_response :success
  end

  test "POST /session with valid credentials creates session and redirects" do
    assert_difference "Session.count", 1 do
      post session_path, params: { email_address: users(:one).email_address, password: "password" }
    end
    assert_redirected_to root_url
  end

  test "POST /session with invalid credentials redirects back with alert" do
    assert_no_difference "Session.count" do
      post session_path, params: { email_address: users(:one).email_address, password: "wrong" }
    end
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "DELETE /session destroys session and redirects to login" do
    sign_in users(:one)
    assert_difference "Session.count", -1 do
      delete session_path
    end
    assert_redirected_to new_session_path
  end
end
