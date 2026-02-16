require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "GET /passwords/new renders successfully" do
    get new_password_path
    assert_response :success
  end

  test "POST /passwords with known email redirects with notice" do
    post passwords_path, params: { email_address: users(:one).email_address }
    assert_redirected_to new_session_path
    assert_match /Password reset instructions sent/, flash[:notice]
  end

  test "POST /passwords with unknown email still redirects with same notice" do
    post passwords_path, params: { email_address: "nobody@example.com" }
    assert_redirected_to new_session_path
    assert_match /Password reset instructions sent/, flash[:notice]
  end

  test "GET /passwords/:token/edit with valid token renders" do
    user = users(:one)
    token = user.password_reset_token
    get edit_password_path(token)
    assert_response :success
  end

  test "GET /passwords/:token/edit with invalid token redirects with alert" do
    get edit_password_path("bad-token")
    assert_redirected_to new_password_path
    assert_match /invalid or has expired/, flash[:alert]
  end

  test "PATCH /passwords/:token with matching passwords resets and redirects" do
    user = users(:one)
    token = user.password_reset_token
    patch password_path(token), params: { password: "newpassword123", password_confirmation: "newpassword123" }
    assert_redirected_to new_session_path
    assert_match /Password has been reset/, flash[:notice]
  end

  test "PATCH /passwords/:token with mismatched passwords redirects back with alert" do
    user = users(:one)
    token = user.password_reset_token
    patch password_path(token), params: { password: "newpassword123", password_confirmation: "different" }
    assert_redirected_to edit_password_path(token)
    assert_match /Passwords did not match/, flash[:alert]
  end
end
