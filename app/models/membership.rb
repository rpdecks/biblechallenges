class Membership < ActiveRecord::Base

  attr_accessor :auto_created_user

  # Constants
  BIBLE_VERSIONS = %w(ASV ESV KJV NASB NKJV)

  # Relations
  belongs_to :user
  belongs_to :challenge
  belongs_to :group

  has_many :membership_readings, dependent: :destroy
  has_many :readings, through: :challenge
  has_many :membership_statistics
  
  # autogenerate has_one associations for all the membership statistic types
  Rails.application.eager_load!
  MembershipStatistic.descendants.each do |stat| 
    has_one stat.name.underscore.to_sym
  end


  #  Validations
  validates :challenge_id, presence: true
  validates :bible_version, presence: true
  validates_uniqueness_of :user_id, scope: :challenge_id
  validates :bible_version, inclusion: {in: BIBLE_VERSIONS}

  # Callbacks

  after_update :recalculate_group_stats

#  after_create :successful_creation_email, unless: 'auto_created_user'
#  after_create :successful_auto_creation_email, if: 'auto_created_user'
#
#  after_create :send_todays_reading

  def to_date_progress_percentage(adate)
    td_total = readings.to_date(adate).count
    read = membership_readings.read.count
    td_total.zero? ? 0 : (read * 100) / td_total
  end

  def completed?
    challenge.readings.count == membership_readings.count
  end

  def self.set_daily_email_jobs
    Membership.all.each do |m|
      reading = m.readings.todays_reading.first

      #set time_zone to the user's time_zone
      user_time_zone = m.user.profile.time_zone
      Time.zone = user_time_zone

      #convert user_time to UTC
      user_reading_hour = m.user.profile.preferred_reading_hour
      user_reading_hour_string = DateTime.now.strftime("%Y-%m-%d") + " " + user_reading_hour.to_s + ":00:00"
      user_reading_hour_utc = Time.zone.parse(user_reading_hour_string).utc

      #schedule the sidekiq job

      if reading #schedule may be done, but still active
        DailyEmailWorker.perform_at(user_reading_hour_utc, reading.id, m.user.id)
      end
    end
  end

  def associate_statistics
    self.membership_statistics << MembershipStatisticProgressPercentage.create
    self.membership_statistics << MembershipStatisticPunctualPercentage.create
    self.membership_statistics << MembershipStatisticRecordSequentialReading.create
  end

  private
  # Callbacks
  def recalculate_group_stats
    if self.group_id.present?
      #group.recalculate_stats
      #replace this with calling group's group_statistics
    end
  end


  # -- emails

  def successful_creation_email
    MembershipMailer.creation_email(self).deliver_now
  end

  def successful_auto_creation_email
    MembershipMailer.auto_creation_email(self).deliver_now
  end
end
