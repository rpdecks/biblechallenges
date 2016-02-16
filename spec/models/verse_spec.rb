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
    describe "by_version" do
      it "returns a specified version when that version exists" do
        matthew1 = Chapter.find_by_book_id_and_chapter_number(40, 1)
        verses = matthew1.verses.by_version("NASB")

        expect(verses.first.version).to eq "NASB"
      end
      it "returns specified RCV version (after adding verse object/text) " do
        matthew1 = Chapter.find_by_book_id_and_chapter_number(40, 1)
          # this 'check' also populates the nonexistant RCV text
        rcv_verses = matthew1.verses.by_version("RCV")

        expect(rcv_verses.first.version).to eq "RCV"
      end
      it "Does not update/replace the RCV verse text if verse_text not updated within past 10 days" do
        psalm23 = Chapter.find_by_book_id_and_chapter_number(19, 23)
        psalm23.verses.by_version("RCV") #initially populates db with RCV verse_text
        Timecop.travel(9.days)

        expect(psalm23.verses.by_version("RCV").first.updated_at.to_date).to eq 9.days.ago.to_date
        Timecop.return
      end
      it "Updates/replaces the RCV verse text if verse_text not updated within past 10 days" do
        psalm23 = Chapter.find_by_book_id_and_chapter_number(19, 23)
        psalm23.verses.by_version("RCV") #initially populates db with RCV verse_text
        Timecop.travel(11.days)
        psalm23.verses.by_version("RCV")
        expect(psalm23.verses.first.updated_at.to_date).to eq Time.zone.now.to_date
        Timecop.return
      end

      it "returns the default version when the specified version does not exist" do
        #how do I put this default version into a constant somewhere?
        matthew1 = Chapter.find_by_book_id_and_chapter_number(40, 1)
        verses = matthew1.verses.by_version("IMAGINARY")
        expect(verses.first.version).to eq "ASV"
      end
    end

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
