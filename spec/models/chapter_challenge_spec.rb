require 'spec_helper'

describe ChapterChallenge do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:chapter_challenge)).to be_valid
    end

    it { should validate_presence_of(:chapter_id) }
    it { should validate_presence_of(:challenge_id) }
  end

  describe "Relations" do
    it { should belong_to(:chapter)} 
    it { should belong_to(:challenge) }
  end

end
