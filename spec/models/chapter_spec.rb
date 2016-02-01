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

  describe "RcvBible"
    it "should do something" do
      something = RcvBible::Reference.text_of("John 1")
      binding.pry
      expect something.not_to be nil
    end




end
