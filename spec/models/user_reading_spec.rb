require 'spec_helper'

describe UserReading, "Relations" do
  it { should belong_to(:user) }
  it { should belong_to(:challenge) }
end

describe UserReading, "Validations" do
  it { should validate_presence_of(:challenge_id) }
  it { should validate_presence_of(:user_id) }
end
