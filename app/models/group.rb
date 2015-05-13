class Group < ActiveRecord::Base

  belongs_to :user
  belongs_to :challenge
  has_many :memberships

end
