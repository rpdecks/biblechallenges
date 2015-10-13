class SignUpViaEmail

  def initialize(email, challenge)
    @email = email
    @challenge = challenge




    create_user_if_doesnt_exist



  end

  private

  def email_is_valid?
    EmailValidator.new(@email).valid?
  end

  def create_user_if_doesnt_exist
    unless User.find_by_email(@email)
      @user = UserCreation.new(email).create_user
    end
  end

end
