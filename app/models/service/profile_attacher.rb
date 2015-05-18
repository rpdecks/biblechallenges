class ProfileAttacher

  def self.attach_profile(user)
    self.new.attach_profile(user)
  end

  def attach_profile(user)
    user.create_profile unless user.profile
  end
end

