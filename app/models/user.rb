class User < ActiveRecord::Base
  include PrettyDate
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  # Relations
  has_many :created_challenges, class_name: "Challenge", foreign_key: :owner_id
  has_many :user_statistics
  has_many :memberships, dependent: :destroy
  has_many :challenges, through: :memberships
  has_many :groups, through: :memberships
  has_many :comments
  has_many :badges, dependent: :destroy
  has_many :membership_readings, through: :memberships

  # autogenerate has_one associations for all the badge types
  Rails.application.eager_load!
  Badge.descendants.each do |badge| 
    has_one badge.name.underscore.to_sym
  end

  UserStatistic.descendants.each do |stat| 
    has_one stat.name.underscore.to_sym
  end

  #Callbacks

  def associate_statistics
    self.user_statistics << UserStatisticChaptersReadAllTime.create
    self.user_statistics << UserStatisticDaysReadInARowCurrent.create
    self.user_statistics << UserStatisticDaysReadInARowAllTime.create
  end
  
  def show_progress_percentage(member, group)
    user_membership = (member.memberships & group.memberships).first
    user_membership.progress_percentage
  end

  def show_last_recorded_reading(member, group)
    user_membership = (member.memberships & group.memberships).first
    user_membership.membership_readings.last.created_at.to_pretty
  end

  def has_logged_a_reading?(member, group)
    user_membership = (member.memberships & group.memberships).first
    MembershipReading.where(membership_id: user_membership).present?
  end

  def find_challenge_group(challenge)
    groups.where(challenge: challenge).first
  end

  def update_stats
    user_statistics.each do |us|
      us.update
    end
  end

  def existing_user?
    !last_sign_in_at.nil?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,15]
      user.name = auth.info.name
      user.image = auth.info.image

      #  profile = Profile.create(username: user.email,
      #                           first_name: name_array[0],
      #                           last_name: name_array[1])
      user.save!
    end
  end
end
