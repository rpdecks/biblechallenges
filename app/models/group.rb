class Group < ActiveRecord::Base

  belongs_to :user
  belongs_to :challenge
  has_many :memberships
  has_many :group_statistics

  validates :user, :challenge, presence: true

end
