class AvatarlyAttacher

  def initialize(user)
    @user = user
  end

  def attach
    if missing_avatar?
      new_avatar = Avatarly.generate_avatar(only_letters(@user.name))
      @user.avatar = StringIO.new(new_avatar)
      @user.avatar_file_name = 'avatarly.png'
      @user.save
    end
  end

  private

  def only_letters(name)
    name.gsub!(/\W/,'')
  end

  def missing_avatar?
    !@user.avatar_file_name
  end

end
