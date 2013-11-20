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
  end

  describe "Class methods" do

    describe ".parse_query" do

      it "returns the fragment and chapter of a query" do

        fragment, chapter = Chapter.parse_query("Matt. 5")
        expect(fragment).to eql "Matt"
        expect(chapter).to match_array ["5"]

        fragment, chapter = Chapter.parse_query("Mat 5")
        expect(fragment).to eql "Mat"
        expect(chapter).to match_array ["5"]

        fragment, chapter = Chapter.parse_query("1 Cor. 8")
        expect(fragment).to eql "1Cor"
        expect(chapter).to match_array ["8"]

        fragment, chapter = Chapter.parse_query("Mat. 5")
        expect(fragment).to eql "Mat"
        expect(chapter).to match_array ["5"]

        fragment, chapter = Chapter.parse_query("1Co 8")
        expect(fragment).to eql "1Co"
        expect(chapter).to match_array ["8"]

        fragment, chapter = Chapter.parse_query("1Co. 8")
        expect(fragment).to eql "1Co"
        expect(chapter).to match_array ["8"]

        fragment, chapter = Chapter.parse_query("2 Tim. 8")
        expect(fragment).to eql "2Tim"
        expect(chapter).to match_array ["8"]
      end

    end

    # describe ".search" do
    #   test_cases_file = File.join(Rails.root,
    #                               "spec/data/example_chapter_queries.yml")
    #   @test_cases = YAML.load_file(test_cases_file)
    #   @test_cases.each do |tc|
    #     fragment, book_id, chapters = tc["fragment"], tc["book_number"], tc["chapters"]

    #     it "should find book_id: #{book_id} and chapters: #{chapters.inspect} for #{fragment.inspect}" do
    #       @expected_chapters = Chapter.where(book_id: book_id, chapter_number: chapters)
    #       result = Chapter.search(fragment)
    #       result.should include(*@expected_chapters)
          
    #       result.length.should == chapters.length
    #     end
    #   end
    # end


  end

end