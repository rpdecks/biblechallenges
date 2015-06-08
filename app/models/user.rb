class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  # Relations
  has_many :created_challenges, class_name: "Challenge", foreign_key: :owner_id
  has_many :memberships, dependent: :destroy
  has_many :challenges, through: :memberships
  has_many :groups, through: :memberships
  has_many :comments
  has_many :badges, dependent: :destroy
  has_one  :profile, dependent: :destroy
  has_many :membership_readings, through: :memberships

  # autogenerate has_one associations for all the badge types
  Rails.application.eager_load!
  Badge.descendants.each do |badge| 
    has_one badge.name.underscore.to_sym
  end


  #Callbacks


  def fullname
    "#{first_name} #{last_name}"
  end

  def first_name
    profile && profile.first_name
  end

  def last_name
    profile && profile.first_name
  end

  def username
    profile && profile.first_name
  end

  def find_challenge_group(challenge)
    groups.where(challenge: challenge).first
  end
end
