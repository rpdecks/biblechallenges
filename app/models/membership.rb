class Membership < ActiveRecord::Base

  attr_accessor :auto_created_user

  # Constants
  BIBLE_VERSIONS = %w(ASV ESV KJV NASB NKJV)

  # Relations
  belongs_to :user
  belongs_to :challenge, counter_cache: true
  belongs_to :group, counter_cache: true

  has_many :membership_readings
  has_many :readings, through: :challenge
  has_many :membership_statistics, dependent: :destroy
  
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
  #after_commit :successful_creation_email, :on => :create
  after_update :recalculate_group_stats

  def to_date_progress_percentage(adate)
    td_total = readings.to_date(adate).count
    read = membership_readings.read.count
    td_total.zero? ? 0 : (read * 100) / td_total
  end

  def completed?
    challenge.readings.count == membership_readings.count
  end

  def update_stats
    membership_statistics.each do |ms|
      ms.update
    end
  end

  def associate_statistics
    self.membership_statistics << MembershipStatisticProgressPercentage.create
    self.membership_statistics << MembershipStatisticOnSchedulePercentage.create
    self.membership_statistics << MembershipStatisticRecordReadingStreak.create
    self.membership_statistics << MembershipStatisticCurrentReadingStreak.create
    self.membership_statistics << MembershipStatisticTotalChaptersRead.create
  end

  def successful_creation_email
    NewMembershipEmailWorker.perform_in(30.seconds, self.id)

    todays_reading = self.readings.todays_reading
    if todays_reading.size > 0
      DailyEmailWorker.perform_in(30.seconds, todays_reading.first.id, self.user_id)
    end
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


  def successful_auto_creation_email
    MembershipMailer.auto_creation_email(self).deliver_now
  end
end
