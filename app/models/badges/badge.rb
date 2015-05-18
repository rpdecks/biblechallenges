class Badge < ActiveRecord::Base
  belongs_to :user


  def self.attach_user_badges(user)
    # Make sure this user has every badge.
    # Adjusted so it only makes one query to check instead of one for each badge.
    # Guy will be happy
    missing_badges = Badge.descendants.map(&:name) - user.badges.map{|b| b.class.name}
    missing_badges.each {|mb| user.badges << mb.constantize.create }
  end

  def self.update_user_badges(user)
    Badge.attach_user_badges(user)
    user.badges.each {|badge| badge.update }
  end

  def update
    # this may be overridden in the subclasses of course
    update_attributes(granted: qualify?) 
  end
end

=begin

thought process:

1.  every user needs to have every possible badge associated with him/her whether they earned it or not
2.  The granted column shows whether the badge is granted or not
3.  every badge is a subclass of Badge and you can silo the details of each badge in each class
4.  to add new badges, just create additional badge subclasses according to the pattern

=end







