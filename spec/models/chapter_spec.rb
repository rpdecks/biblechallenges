require 'spec_helper'

describe Chapter, "Relations" do
  it { should have_many(:challenges).through(:chapter_challenges) }
  it { should have_many(:chapter_challenges) }
end

describe Chapter, "Validations" do
end


describe Chapter, "Class methods" do

  describe "+search" do
    test_cases_file = File.join(Rails.root,
                                "spec/data/example_chapter_queries.yml")
    @test_cases = YAML.load_file(test_cases_file)
    @test_cases.each do |tc|
      fragment, book_id, chapters = tc["fragment"], tc["book_number"], tc["chapters"]

      it "should find book_id: #{book_id} and chapters: #{chapters.inspect} for #{fragment.inspect}" do
        @expected_chapters = Chapter.where(book_id: book_id, chapter_number: chapters)
        result = Chapter.search(fragment)
        result.should include(*@expected_chapters)
        
        result.length.should == chapters.length
      end
    end
  end

  describe "+parse_query" do

    it "should return the fragment and chapter of a query" do

      fragment, chapter = Chapter.parse_query("Matt. 5")
      fragment.should eql("Matt")
      chapter.should eql(["5"])

      fragment, chapter = Chapter.parse_query("Mat 5")
      fragment.should eql("Mat")
      chapter.should eql(["5"])

      fragment, chapter = Chapter.parse_query("1 Cor. 8")
      fragment.should eql("1Cor")
      chapter.should eql(["8"])

      fragment, chapter = Chapter.parse_query("Mat. 5")
      fragment.should eql("Mat")
      chapter.should eql(["5"])

      fragment, chapter = Chapter.parse_query("1Co 8")
      fragment.should eql("1Co")
      chapter.should eql(["8"])

      fragment, chapter = Chapter.parse_query("1Co. 8")
      fragment.should eql("1Co")
      chapter.should eql(["8"])

      fragment, chapter = Chapter.parse_query("2 Tim. 8")
      fragment.should eql("2Tim")
      chapter.should eql(["8"])
    end

  end
end
