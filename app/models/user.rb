class User < ActiveRecord::Base
  include PrettyDate
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  # Validations
  validates :name, presence: true

  # Relations
  has_many :created_challenges, class_name: "Challenge", foreign_key: :owner_id
  has_many :user_statistics
  has_many :memberships, dependent: :destroy
  has_many :challenges, through: :memberships
  has_many :groups, through: :memberships
  has_many :comments
  has_many :badges, dependent: :destroy
  has_many :membership_readings, through: :memberships

  has_attached_file :avatar,
    :styles => {
    :medium => "300x300>",
    :thumb => "75x75>" },
    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  #Callbacks
  #after_create :associate_statistics
  before_save :set_default_values

  # autogenerate has_one associations for all the badge types
  Rails.application.eager_load!
  Badge.descendants.each do |badge|
    has_one badge.name.underscore.to_sym
  end

  UserStatistic.descendants.each do |stat| 
    has_one stat.name.underscore.to_sym
  end

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
      # timezone
      # preferred reading hour

      user.save!
    end
  end

  private

  def set_default_values
    self.preferred_reading_hour ||= "3"
    self.time_zone ||= "Central Time (US & Canada)"
  end
end
