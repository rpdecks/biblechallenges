# == Schema Information
#
# Table name: user_readings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  reading_id   :integer
#  challenge_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class UserReading < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :challenge

  validates :challenge_id, presence: true
  validates :user_id, presence: true
end
