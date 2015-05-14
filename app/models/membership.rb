class Membership < ActiveRecord::Base

  attr_accessor :auto_created_user

  # Constants
  BIBLE_VERSIONS = %w(ASV ESV KJV NASB NKJV)

  # Relations
  belongs_to :user
  belongs_to :challenge
  belongs_to :group

  has_many :membership_readings, dependent: :destroy
  has_many :readings, through: :membership_readings
  has_many :membership_statistics


  #  Validations
  validates :challenge_id, presence: true
  validates :bible_version, presence: true
  validates_uniqueness_of :user_id, scope: :challenge_id
  validates :bible_version, inclusion: {in: BIBLE_VERSIONS}

  # Callbacks
  after_create :associate_readings

  after_update :recalculate_group_stats

#  after_create :successful_creation_email, unless: 'auto_created_user'
#  after_create :successful_auto_creation_email, if: 'auto_created_user'
#
#  after_create :send_todays_reading


  def overall_progress_percentage
    mr_total = membership_readings.count
    read = membership_readings.read.count
    mr_total.zero? ? 0 : (read * 100) / mr_total
  end

  def to_date_progress_percentage(adate)
    td_total = readings.to_date(adate).count
    read = membership_readings.read.count
    td_total.zero? ? 0 : (read * 100) / td_total
  end

  def punctual_reading_percentage
    td_total = readings.to_date(Date.today).count
    punct_total = membership_readings.punctual.count
    td_total.zero? ? 0 : (punct_total * 100) / td_total
  end

  def recalculate_stats
    self.punctual_reading_percentage = punctual_reading_percentage
    self.rec_sequential_reading_count = record_sequential_reading_count
    self.progress_percentage = overall_progress_percentage
    self.save
  end

  def record_sequential_reading_count
    record = 0
    running_count = 0
    self.membership_readings.each do |r|
      if r.state == 'read' && r.punctual == 1
        running_count += 1
      else
        if record < running_count
          record = running_count
        end
        running_count = 0
      end
    end
    record
  end

  def completed?
    membership_readings.count == membership_readings.read.count
  end

  def send_todays_reading  #this feels bad ask jose
    r = readings.find_by_date(Date.today)
    if r
      mr = r.membership_readings.find_by_reading_id_and_membership_id(r.id, self.id)
      MembershipReadingMailer.daily_reading_email(mr).deliver_now if mr
    end
  end

  def associate_statistics
    self.membership_statistics << MembershipStatisticOverallProgressPercentage.create
  end

  private

  # Callbacks
  def recalculate_group_stats
    if self.group_id.present?
      group.recalculate_stats
    end
  end


  # - after_create
  def associate_readings
    self.readings << challenge.readings
  end
  # -- emails
  def successful_creation_email
    MembershipMailer.creation_email(self).deliver_now
  end
  def successful_auto_creation_email
    MembershipMailer.auto_creation_email(self).deliver_now
  end


end
