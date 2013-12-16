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

  def overall_progress_percentage
    mr_total = membership_readings.count
    read = membership_readings.read.count
    mr_total.zero? ? 0 : (read * 100) / mr_total
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
