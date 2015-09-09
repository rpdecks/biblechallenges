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

  # Scopes
  scope :by_group, -> { order(:group_id) }


  #  Validations
  validates :challenge_id, presence: true
  validates :user_id, presence: true
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
    self.membership_statistics.each do |ms|
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
    send_reading_email
  end

  def successful_auto_creation_email(membership, password)
    NewAutoMembershipEmailWorker.perform_in(30.seconds, membership.id, password)
    send_reading_email
  end

  def send_reading_email
    todays_readings = self.readings.todays_readings.pluck(:id)
    if todays_readings.size > 0 && self.user.reading_notify == true
      DailyEmailWorker.perform_in(30.seconds, todays_readings, self.user_id)
    end
  end

  def last_recorded_reading_time
    membership_readings.order(:created_at).last.created_at
  end

  def x_of_total_read
    "#{membership_readings.size} of #{readings.size}"
  end


  private
  # Callbacks
  def recalculate_group_stats
    if self.group_id.present?
      #group.recalculate_stats
      #replace this with calling group's group_statistics
    end
  end
end
