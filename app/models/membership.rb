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
  after_create :successful_creation_email, unless: 'auto_created_user'
  after_create :successful_auto_creation_email, if: 'auto_created_user'

  private

  # Callbacks

  # - after_create
  def successful_creation_email
    MembershipMailer.creation_email(self).deliver
  end
  def successful_auto_creation_email
    MembershipMailer.auto_creation_email(self).deliver
  end

end
