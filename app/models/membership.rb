class Membership < ActiveRecord::Base
  attr_accessible :challenge_id, :user_id, :username, :firstname, :lastname, :email


  belongs_to :user
  belongs_to :challenge

  validates :email, presence: true
end
