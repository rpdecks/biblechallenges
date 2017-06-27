require 'spec_helper'

describe ReadingPrompt do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:reading_prompt)).to be_valid
    end

    it { should validate_presence_of(:reading_id) }
  end
end
