User.find_or_create_by!(email_address: "test@example.com") do |u|
  u.password = "password"
end
