require 'spec_helper'

describe Chapter, "Relations" do
  it { should have_many(:challenges).through(:chapter_challenges) }
  it { should have_many(:chapter_challenges) }
end

describe Chapter, "Validations" do
end


describe Chapter, "Class methods" do

  def Chapter.search(query)
    fragment, chapters = parse_query(query)

    # First search by fragment
    bookfrag = Bookfrag.where("upper(:query) like upper(fragment) || '%'",
                              query: fragment).first
    matches = where(book_id: bookfrag.try(:book_id))
    .where(chapter_number: chapters)

    # If nothing found, then search by Chapter name
    unless matches.length > 0 # Using .any? here causes an extra query
      matches = where("upper(name) like upper(:query)", query: "#{fragment}")
      .where(chapter_number: chapters)
    end

    matches
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
