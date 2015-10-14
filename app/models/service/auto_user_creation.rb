class AutoUserCreation
  def initialize(email)
    @email = email
  end

  def create_user
    password = auto_generated_password
    name = @email.split("@").first
    user = User.create(email: @email, name: name, password: password, password_confirmation: password)
    user.save

    UserCompletion.new(user)

    return user
  end

  private

  def auto_generated_password
    SecureRandom.hex(4)
  end
end
