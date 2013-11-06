require 'spec_helper'

describe Parser do
  
  describe "parse_query" do  # Ex Matt 1

    it "should return the fragment and chapter(s) of a query" do
      fragment, chapter = Parser.parse_query("Matt. 5")
      fragment.should eql("Matt")
      chapter.should eql(["5"])

      fragment, chapter = Parser.parse_query("Mat 5")
      fragment.should eql("Mat")
      chapter.should eql(["5"])

      fragment, chapter = Parser.parse_query("1 Cor. 8")
      fragment.should eql("1Cor")
      chapter.should eql(["8"])

      fragment, chapter = Parser.parse_query("Mat. 5")
      fragment.should eql("Mat")
      chapter.should eql(["5"])

      fragment, chapter = Parser.parse_query("1Co 8")
      fragment.should eql("1Co")
      chapter.should eql(["8"])

      fragment, chapter = Parser.parse_query("1Co. 8")
      fragment.should eql("1Co")
      chapter.should eql(["8"])

      fragment, chapter = Parser.parse_query("2 Tim. 8")
      fragment.should eql("2Tim")
      chapter.should eql(["8"])

      fragment, chapter = Parser.parse_query("2 Tim. 1..4")
      fragment.should eql("2Tim")
      chapter.should eql(["1", "2", "3","4"])

      fragment, chapter = Parser.parse_query("Gen. 1-3")
      fragment.should eql("Gen")
      chapter.should eql(["1", "2", "3"])

    end

  end

end

