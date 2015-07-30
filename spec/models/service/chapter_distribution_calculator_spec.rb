require 'spec_helper'

describe ChapterDistributionCalculator do

  it "correctly distributes with one chapter per day" do
    result = ChapterDistributionCalculator.new(num_days: 5, num_chapters: 5).distribution
    
    expect(result.size).to eq 5  # 5 days
    result.each {|r| expect(r).to eq 1}  # 1 per day
    expect(result.reduce(:+)).to eq 5  # total of 5 chapters
  end

  it "correctly distributes with two chapters per day" do
    result = ChapterDistributionCalculator.new(num_days: 6, num_chapters: 12).distribution
    
    expect(result.size).to eq 6   # 6 days
    result.each {|r| expect(r).to eq 2}  # 2 per day
    expect(result.reduce(:+)).to eq 12  # total of 12 chapters
  end

  it "correctly distributes with one chapter per day and a remainder" do
    num_days = 1000
    num_chapters = 1189
    result = ChapterDistributionCalculator.new(num_days: num_days, num_chapters: num_chapters).distribution
    
    expect(result.size).to eq num_days
    result.each {|r| expect(r).to be_between(1,2)}
    expect(result.reduce(:+)).to eq num_chapters
  end

  it "correctly distributes with one chapter per day and a remainder" do
    num_days = 500
    num_chapters = 1189
    result = ChapterDistributionCalculator.new(num_days: num_days, num_chapters: num_chapters).distribution
    
    expect(result.size).to eq num_days
    result.each {|r| expect(r).to be_between(2,3)}
    expect(result.reduce(:+)).to eq num_chapters
  end
  it "correctly distributes with one chapter per day and a remainder" do
    result = ChapterDistributionCalculator.new(num_days: 30, num_chapters: 550).distribution
    expect(result.size).to eq 30
    expect(result.reduce(:+)).to eq 550
  end
end

