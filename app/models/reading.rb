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
  attr_accessible :chapter, :challenge
  belongs_to :challenge
  belongs_to :chapter

  has_many :user_readings
  has_many :users, through: :user_readings

  validates :chapter_id, presence: true
  validates :challenge_id, presence: true
  validates :date, presence: true
end
