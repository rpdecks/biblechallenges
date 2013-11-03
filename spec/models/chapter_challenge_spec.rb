require 'spec_helper'

describe ChapterChallenge, "Relations" do
  it { should belong_to(:chapter)} 
  it { should belong_to(:challenge) }
end

describe ChapterChallenge, "Validations" do
  it { should validate_presence_of(:chapter_id) }
  it { should validate_presence_of(:challenge_id) }
end
