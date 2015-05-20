puts "seeding users..."
User.delete_all
User.create!(
  [
    { id: 1, email: "guy.cao@bfa.org", password: ENV["DEFAULT_PASSWORD"] }
  ]
)

