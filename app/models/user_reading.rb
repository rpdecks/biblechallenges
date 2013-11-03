class UserReading < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :challenge

  validates :challenge_id, presence: true
  validates :user_id, presence: true
end
