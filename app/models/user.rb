class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  # Relations
  has_many :created_challenges, class_name: "Challenge", foreign_key: :owner_id
  has_many :memberships, dependent: :destroy
  has_many :challenges, through: :memberships
  has_many :groups, through: :memberships
  has_many :comments
  has_many :badges
  has_one  :profile, dependent: :destroy
  has_many :membership_readings, through: :memberships


  #Callbacks

  after_create :add_profile

  delegate :first_name, :last_name, :username, to: :profile

  def fullname
    "#{first_name} #{last_name}"
  end

  def add_profile
    self.create_profile
  end



end
