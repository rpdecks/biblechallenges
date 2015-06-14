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

  describe "Scopes" do
    describe "Verses by range" do
      # assuming Genesis 1 is Chapter.first; this may cause problems later.  sorry in advance
      # this chapter has 31 verses
      last_verse = 31


      it "should return all verses when params are absent" do
        expect(Chapter.first.verses_by_range.size).to eq last_verse
      end
      it "should return the verses in the range if start_verse and end_verse are present" do
        expect(Chapter.first.verses_by_range(start_verse: 3, end_verse: 5).size).to eq 3
        expect(Chapter.first.verses_by_range(start_verse: 3, end_verse: 5).first.verse_number).to eq 3
        expect(Chapter.first.verses_by_range(start_verse: 3, end_verse: 5).last.verse_number).to eq 5
      end
      it "should return the first X verses up to end_verse if only end_verse is present" do
        expect(Chapter.first.verses_by_range(end_verse: 5).size).to eq 5
        expect(Chapter.first.verses_by_range(end_verse: 5).last.verse_number).to eq 5
      end
      it "should return all the verses after start_verse if only start_verse is present" do
        expect(Chapter.first.verses_by_range(start_verse: 30).size).to eq 2
        expect(Chapter.first.verses_by_range(start_verse: 30).last.verse_number).to eq last_verse
      end



    end
  end


end
