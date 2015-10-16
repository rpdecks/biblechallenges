class Group < ActiveRecord::Base

  belongs_to :user
  belongs_to :challenge
  has_many :members, through: :memberships, source: :user
  has_many :memberships
  has_many :group_statistics, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :challenge, :user, presence: true

  Rails.application.eager_load!
  GroupStatistic.descendants.each do |stat| 
    has_one stat.name.underscore.to_sym
  end

  def is_an_owner?(user)
    self.owner.id == user.id
  end

  def has_member?(member)
    members.include?(member)
  end

  def remove_all_members_from_group
    self.memberships.each do |m|
      m.update_attributes(group_id: nil)
    end
  end

  def update_stats
    GroupStatisticAttacher.attach_statistics(self)
    self.group_statistics.each do |gs|
      gs.update
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
