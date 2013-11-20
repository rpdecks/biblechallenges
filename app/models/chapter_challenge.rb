# == Schema Information
#
# Table name: chapter_challenges
#
#  id           :integer          not null, primary key
#  challenge_id :integer
#  chapter_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ChapterChallenge < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :chapter
  belongs_to :challenge

  validates :chapter_id, presence: true
  validates :challenge_id, presence: true
end
