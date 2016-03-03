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

    describe "by_range" do
      chapter = Chapter.find_by_book_name_and_chapter_number("Genesis", 1)
      last_verse = 31 # Genesis 1 has 31 verses

      it "should return all verses when params are absent" do
        expect(chapter.verses.by_range.size).to eq last_verse
      end
      it "should return the verses in the range if start_verse and end_verse are present" do
        expect(chapter.verses.by_range(start_verse: 3, end_verse: 5).size).to eq 3
        expect(chapter.verses.by_range(start_verse: 3, end_verse: 5).first.verse_number).to eq 3
        expect(chapter.verses.by_range(start_verse: 3, end_verse: 5).last.verse_number).to eq 5
      end
      it "should return the first X verses up to end_verse if only end_verse is present" do
        expect(chapter.verses.by_range(end_verse: 5).size).to eq 5
        expect(chapter.verses.by_range(end_verse: 5).last.verse_number).to eq 5
      end
      it "should return all the verses after start_verse if only start_verse is present" do
        expect(chapter.verses.by_range(start_verse: 30).size).to eq 2
        expect(chapter.verses.by_range(start_verse: 30).last.verse_number).to eq last_verse
      end

    end
  end
    

end
