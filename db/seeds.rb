User.create!(
  email: "admin@example.com",
  password: "password123",
  password_confirmation: "password123",
  confirmed_at: Time.now,
  uid: "admin@example.com",
  provider: "email"
)
