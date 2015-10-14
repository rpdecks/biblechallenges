class User < ActiveRecord::Base
  include PrettyDate
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  # Validations
  validates :name, :email, presence: true
  validates :email, uniqueness: true

  # Relations
  has_many :created_challenges, class_name: "Challenge", foreign_key: :owner_id
  has_many :user_statistics, dependent: :destroy
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
    :s3_host_name => ENV["AWS_HOST_NAME"],
    :default_url => "default_avatar.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)

    if user
      user.provider = auth.provider
      user.uid = auth.uid
      user.image = auth.info.image
      return user
    end

    User.where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
      u.provider = auth.provider
      u.uid = auth.uid
      u.email = auth.info.email
      u.password = Devise.friendly_token[0,15]
      u.name = auth.info.name
      u.image = auth.info.image
      u.save!
    end
  end

  def is_a_challenge_owner?
    created_challenges.present?
  end

  #Callback
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

  def find_challenge_group(challenge)
    groups.where(challenge: challenge).first
  end

  def update_stats
    self.user_statistics.each do |us|
      us.update
    end
  end

  def last_recorded_reading_time
    membership_readings.order(:created_at).last.created_at
  end

  def last_chapter_posted
    membership_readings.order(:created_at).last.reading.chapter.book_and_chapter
  end

  def existing_user?
    !last_sign_in_at.nil?
  end

  def date_by_timezone
    if self.time_zone.present?
      Time.now.in_time_zone(self.time_zone).to_date
    else
      Time.zone.now.to_date
    end
  end

  private

  def set_default_values
    self.preferred_reading_hour ||= "6"
    self.time_zone ||= "Eastern Time (US & Canada)"
  end
end
