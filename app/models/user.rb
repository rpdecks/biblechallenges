class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid

  has_many :createdchallenges, class_name: "Challenge", foreign_key: :owner_id
  has_many :memberships
  has_many :joinedchallenges, through: :memberships
end
