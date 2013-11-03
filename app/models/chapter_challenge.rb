class ChapterChallenge < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :chapter
  belongs_to :challenge

  validates :chapter_id, presence: true
  validates :challenge_id, presence: true
end
