require 'spec_helper'

describe User, "Relations" do

  it { should have_many(:createdchallenges) }
  it { should have_many(:memberships) }
  it { should have_many(:joinedchallenges).through(:memberships)}
end
