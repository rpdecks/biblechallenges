require 'spec_helper'

describe Reading, "Relations" do
  it { should belong_to(:challenge) }
  it { should belong_to(:chapter) }

  it { should have_many(:users).through(:user_readings) }
  it { should have_many(:user_readings) }
end

describe Reading, "Validations" do
  it { should validate_presence_of(:chapter_id) }
  it { should validate_presence_of(:challenge_id) }
  it { should validate_presence_of(:date) }
end
