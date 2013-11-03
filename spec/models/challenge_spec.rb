require 'spec_helper'

describe Challenge, "Validations" do
  it { should validate_presence_of(:begindate) }
  it { should validate_presence_of(:enddate) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner_id) }
  it { should validate_presence_of(:subdomain) }
  it { should validate_uniqueness_of(:subdomain) }

  it "should not validate a challenge with enddate < begindate" do
    @challenge = FactoryGirl.build(:challenge, enddate: Time.now, begindate: Time.now + 1.day)
    @challenge.valid?
    @challenge.errors.messages[:enddate].should include("The challenge begin and end dates must be sequential")
  end
end

describe Challenge, "Relations" do
  it { should belong_to(:owner) }
  it { should have_many(:memberships) }
  it { should have_many(:members).through(:memberships)}
  it { should have_many(:readings) }
end
