require 'spec_helper'

describe Parser do


  describe "Class methods" do

    describe ".parse_query" do

      it "returns the fragment and chapter of a query" do

        fragment, chapter = Parser.parse_query("Matt. 5")
        expect(fragment).to eql "Matt"
        expect(chapter).to match_array ["5"]

        fragment, chapter = Parser.parse_query("Mat 5")
        expect(fragment).to eql "Mat"
        expect(chapter).to match_array ["5"]

        fragment, chapter = Parser.parse_query("1 Cor. 8")
        expect(fragment).to eql "1Cor"
        expect(chapter).to match_array ["8"]

        fragment, chapter = Parser.parse_query("Mat. 5")
        expect(fragment).to eql "Mat"
        expect(chapter).to match_array ["5"]

        fragment, chapter = Parser.parse_query("1Co 8")
        expect(fragment).to eql "1Co"
        expect(chapter).to match_array ["8"]

        fragment, chapter = Parser.parse_query("1Co. 8")
        expect(fragment).to eql "1Co"
        expect(chapter).to match_array ["8"]

        fragment, chapter = Parser.parse_query("2 Tim. 8")
        expect(fragment).to eql "2Tim"
        expect(chapter).to match_array ["8"]
      end
       
    end

  end

end