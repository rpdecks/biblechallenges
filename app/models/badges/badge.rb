class Badge < ActiveRecord::Base
  belongs_to :user

  def self.attach_user_badges(user)
    # Make sure this user has every badge
    Badge.descendants.each do |b|
      unless user.badges.find_by_type(b.name)
        user.badges << b.create
      end
    end
  end

  def self.update_user_badges(user)
    Badge.attach_user_badges(user)

    user.badges.each do |badge|
      badge.update
    end
  end

  def update
    update_attributes(granted: qualify?) 
  end
end

=begin

thought process:

1.  every user needs to have every possible badge associated with him/her
2.  The granted column shows whether the badge is granted or not
3.  for every badge a user has, the badge checks whether the user qualifies 
    and if he does, the badge is granted
=end







