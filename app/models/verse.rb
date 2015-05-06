# == Schema Information
#
# Table name: verses
#
#  id             :integer          not null, primary key
#  version        :string(255)
#  book_name      :string(255)
#  chapter_number :integer
#  verse_number   :integer
#  versetext      :text
#  book_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  chapter_index  :integer
#

class Verse < ActiveRecord::Base


  # Relations
  belongs_to :chapter, foreign_key: :chapter_index

  def self.by_version(version)
    #if the chosen version is not in the verses table, go with ASV
    #this default version should probably be in a constant  (ASV)
    response = where(version: version)
    response.any? ? response : where(version: "ASV")
  end

end
