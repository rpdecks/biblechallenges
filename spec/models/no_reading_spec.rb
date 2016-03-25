require 'spec_helper'

describe NoReading do
  describe '#reading_time' do
    it 'returns no reading time for NoReading' do
      expect(NoReading.new.reading_time).to eq(MembershipReading::NO_READING)
    end
  end

  describe '#chapter' do
    it 'returns no reading class for chapter method' do
      expect(NoReading.new.chapter_name).to eq(MembershipReading::NO_CHAPTER)
    end
  end
end
