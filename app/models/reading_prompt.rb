class ReadingPrompt < ActiveRecord::Base

  belongs_to :reading

  validates :reading_id, presence: true
end
