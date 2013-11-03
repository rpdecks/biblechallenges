class Chapter < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :chapter_challenges
  has_many :challenges, through: :chapter_challenges
end
