class Membership < ActiveRecord::Base
  attr_accessible :challenge_id, :user_id, :username, :firstname, :lastname, :email

  belongs_to :user
  belongs_to :challenge

  validates :email, presence: true
  validates :challenge_id, presence: true
  validates :username, presence: true, on: :update
  validates :firstname, presence: true, on: :update
  validates :lastname, presence: true, on: :update

#  validates_uniqueness_of :email, scope: :challenge_id
#  validates_format_of :email, :with => /@/, message: "doesn't really look like a real email address"
#  validates_uniqueness_of :username, scope: :challenge_id, on: :update





end
