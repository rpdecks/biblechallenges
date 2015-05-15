class Group < ActiveRecord::Base

  belongs_to :user
  belongs_to :challenge
  has_many :memberships

  def remove_all_members_from_group
    self.memberships.each do |m|
      m.update_attributes(group_id: nil)
    end
  end

  def add_user_to_group(challenge, user)
    #find or create membership for user
    membership = challenge.membership_for(user) || Membership.new(user_id: user.id)
    membership.challenge = challenge
    membership.group = self
    membership.save
  end

  def remove_user_from_group(challenge, user)
    membership = challenge.membership_for(user)
    membership.group = nil
    membership.save
  end
end
