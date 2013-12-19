# == Schema Information
#
# Table name: readings
#
#  id           :integer          not null, primary key
#  chapter_id   :integer
#  challenge_id :integer
#  date         :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Reading < ActiveRecord::Base
  attr_accessible :chapter, :challenge, :date

  # Relations
  belongs_to :challenge
  belongs_to :chapter
  has_many :membership_readings, dependent: :destroy
  has_many :memberships, through: :membership_readings
  has_many :comments, as: :commentable
  
  # Validations
  validates :chapter_id, presence: true
  validates :challenge_id, presence: true
  validates :date, presence: true

  #Scopes
  scope :to_date, lambda { | a_date | where("date <= ?", a_date) }

  def last_read_by
    #returns the user who last read this reading
    membership_readings.read.order("updated_at").first.membership.user
  end
end
