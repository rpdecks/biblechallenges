require 'spec_helper'

describe Verse do

  describe "Validations" do
    it "has a valid factory" do
      expect(create(:verse)).to be_valid
    end
  end

  describe "Relations" do
  end

  describe "scopes" do
    it "returns a specified version when that version exists" do
      matthew1 = Chapter.find_by_book_id_and_chapter_number(40, 1)
      verses = matthew1.verses.by_version("NASB")
      expect(verses.first.version).to eq "NASB"
    end

    it "returns the default version when the specified version does not exist" do
      #how do I put this default version into a constant somewhere?
      matthew1 = Chapter.find_by_book_id_and_chapter_number(40, 1)
      verses = matthew1.verses.by_version("IMAGINARY")
      expect(verses.first.version).to eq "ASV"
    end
  end
    

end
