class Verse < ActiveRecord::Base
  require 'htmlentities'


  # Relations
  belongs_to :chapter, foreign_key: :chapter_index

  def self.by_version(version)
    #if the chosen version is not in the verses table, go with ASV
    #this default version should probably be in a constant  (ASV)
    response = where(version: version)
    response.any? ? response : where(version: "ASV")
  end

  def text
    coder = HTMLEntities.new
    coder.decode(self.versetext)
  end
end
