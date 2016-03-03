require 'spec_helper'

describe Chapter do

  describe "Validations" do
    it "has a valid factory" do
      expect(create(:chapter)).to be_valid
    end
  end
 
  describe "Relations" do
    it { should have_many(:challenges).through(:chapter_challenges) }
    it { should have_many(:chapter_challenges) }
    it { should have_many(:verses) }
  end

  describe "by_version" do
    it "returns a specified version when that version exists" do
      matthew1 = Chapter.find_by_book_id_and_chapter_number(40, 1)
      verses = matthew1.by_version("NASB")

      expect(verses.first.version).to eq "NASB"
    end
    it "returns specified RCV version (after adding verse object/text) " do
      matthew1 = Chapter.find_by_book_id_and_chapter_number(40, 1)
        # this 'check' also populates the nonexistant RCV text
      rcv_verses = matthew1.by_version("RCV")

      expect(rcv_verses.first.version).to eq "RCV"
    end
    it "Does not update/replace the RCV verse text if verse_text not updated within past 10 days" do
      psalm23 = Chapter.find_by_book_id_and_chapter_number(19, 23)
      psalm23.by_version("RCV") #initially populates db with RCV verse_text
      Timecop.travel(9.days)

      expect(psalm23.by_version("RCV").first.updated_at.to_date).to eq 9.days.ago.to_date
      Timecop.return
    end
    it "Updates/replaces the RCV verse text if verse_text not updated within expiration period" do
      psalm23 = Chapter.find_by_book_id_and_chapter_number(19, 23)
      psalm23.by_version("RCV") #initially populates db with RCV verse_text
      Timecop.travel((RetrieveRcv::EXPIRED_CACHE + 1).days)
      psalm23.by_version("RCV")
      expect(psalm23.verses.first.updated_at.to_date).to eq Time.zone.now.to_date
      Timecop.return
    end

    it "returns the default version when the specified version does not exist" do
      matthew1 = Chapter.find_by_book_id_and_chapter_number(40, 1)
      verses = matthew1.by_version("IMAGINARY")
      expect(verses.first.version).to eq Verse::DEFAULT_VERSION
    end
  end

  describe "RcvBible"
    it "should do something" do
      something = RcvBible::Reference.new("John 1").verses
      expect(something).not_to be nil
    end
end
