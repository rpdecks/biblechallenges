class Reading < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :challenge
  belongs_to :chapter

  has_many :user_readings
  has_many :users, through: :user_readings

  validates :chapter_id, presence: true
  validates :challenge_id, presence: true
  validates :date, presence: true
end
