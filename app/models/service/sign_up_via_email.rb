class SignUpViaEmail

  def initialize(email, challenge)
    @email = email
    @challenge = challenge
    sign_up
  end

  def sign_up
    return if email_not_valid?
    @user = find_or_create_user
    return if user_already_in_challenge?
    add_user_to_challenge(@user)
  end

  def flash
    @flash
  end

  private

  def add_user_to_challenge(user)
    membership = @challenge.join_new_member(user)
    if @new_user
      MembershipCompletion.new(membership, password: user.password)
    else
      MembershipCompletion.new(membership)
    end
    @flash = "You have successfully added #{user.name} to this challenge"
  end

  def email_not_valid?
    unless EmailValidator.new(@email).valid? 
      @flash = "Please enter a valid email"
      return true
    end
  end

  def user_already_in_challenge?
    if @challenge.has_member?(@user)
      @flash = "#{@user.name} is already in this challenge"
      return true
    end
  end

  def email_is_valid?
    EmailValidator.new(@email).valid?
  end

  def find_or_create_user
    if user = User.find_by_email(@email)
      user
    else
      @new_user = true
      user = AutoUserCreation.new(@email).create_user
    end
  end

end
