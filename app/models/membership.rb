# == Schema Information
#
# Table name: memberships
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  challenge_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  bible_version :string(255)      default("ASV")
#

class Membership < ActiveRecord::Base

  include UrlHashable

  attr_accessible :challenge, :user, :bible_version
  attr_accessor :auto_created_user

  # Constants
  BIBLE_VERSIONS = %w(ASV ESV KJV NASB NKJV)

  # Relations
  belongs_to :user
  belongs_to :challenge
  has_many :membership_readings, dependent: :destroy
  has_many :readings, through: :membership_readings


  #  Validations
  validates :challenge_id, presence: true
  validates :bible_version, presence: true
  validates_uniqueness_of :user_id, scope: :challenge_id
  validates :bible_version, inclusion: {in: BIBLE_VERSIONS}

  # Callbacks
  after_create :associate_readings
  after_create :successful_creation_email, unless: 'auto_created_user'
  after_create :successful_auto_creation_email, if: 'auto_created_user'

  after_create :send_todays_reading

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

  def completed?
    membership_readings.count == membership_readings.read.count
  end

  def send_todays_reading  #this feels bad ask jose
    r = readings.find_by_date(Date.today)
    if r
      mr = r.membership_readings.find_by_reading_id_and_membership_id(r.id, self.id)
      MembershipReadingMailer.daily_reading_email(mr).deliver if mr
    end
  end

  private

  # Callbacks

  # - after_create
  def associate_readings
    self.readings << challenge.readings
  end
  # -- emails
  def successful_creation_email
    MembershipMailer.creation_email(self).deliver
  end
  def successful_auto_creation_email
    MembershipMailer.auto_creation_email(self).deliver
  end


end
