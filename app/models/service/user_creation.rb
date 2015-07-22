class UserCreation
  def initialize(email)
    @email = email
  end

  def create_user
    @password = SecureRandom.hex(4)
    name = @email.split("@").first.gsub(/[^0-9a-z ]/i, '')
    User.create(email: @email, name: name, password: @password, password_confirmation: @password)
  end
end
