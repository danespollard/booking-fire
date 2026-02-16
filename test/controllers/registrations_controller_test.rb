require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "GET /registration/new renders successfully" do
    get new_registration_path
    assert_response :success
  end

  test "POST /registration with valid params creates user and redirects to root" do
    assert_difference "User.count", 1 do
      post registration_path, params: { user: { email_address: "new@example.com", password: "password123", password_confirmation: "password123" } }
    end
    assert_redirected_to root_url
  end

  test "POST /registration with invalid params re-renders form with 422" do
    assert_no_difference "User.count" do
      post registration_path, params: { user: { email_address: "", password: "short", password_confirmation: "mismatch" } }
    end
    assert_response :unprocessable_entity
  end
end
