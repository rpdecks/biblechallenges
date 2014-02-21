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

  describe "Class methods" do

    describe ".search" do
      test_cases_file = File.join(Rails.root,
                                  "spec/data/example_chapter_queries.yml")
      @test_cases = YAML.load_file(test_cases_file)
      @test_cases.each do |tc|
        fragment, book_id, chapters = tc["fragment"], tc["book_number"], tc["chapters"]

        it "should find book_id: #{book_id} and chapters: #{chapters.inspect} for #{fragment.inspect}" do
          @expected_chapters = Chapter.where(book_id: book_id, chapter_number: chapters)
          results = Chapter.search(fragment)
          results.flatten.should include(*@expected_chapters)
          
          #result.length.should == chapters.length # TODO: Need to
          #implement this for multi-span fragments
        end
      end
    end
  end

end
