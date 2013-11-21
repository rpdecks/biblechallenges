require 'spec_helper'

describe Verse do

  describe "Validations" do
    it "has a valid factory" do
      expect(create(:verse)).to be_valid
    end
  end

  describe "Relations" do
  end

end