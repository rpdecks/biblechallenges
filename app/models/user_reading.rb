# == Schema Information
#
# Table name: user_readings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  reading_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserReading < ActiveRecord::Base
  attr_accessible :user, :reading
  belongs_to :user
  belongs_to :reading

  validates :reading_id, presence: true
  validates :user_id, presence: true
end
