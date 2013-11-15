require 'spec_helper'

describe Membership, "Relations" do
  it { should belong_to(:user) }
  it { should belong_to(:challenge) }
end

describe Membership, "Validations" do


  it "is invalid without an email" do
    membership = FactoryGirl.build(:membership, email: "")
    expect(membership).to have(1).errors_on(:email)
  end

  it "is invalid without a challenge_id" do
    membership = FactoryGirl.build(:membership, challenge_id: nil)
    expect(membership).to have(1).errors_on(:challenge_id)
  end

  it "is valid without a user name on create" do
    membership = FactoryGirl.build(:membership, username: "")
    expect(membership).to have(0).errors_on(:username)
  end

  it "is invalid without a user name on update" do
    membership = FactoryGirl.create(:membership, username: "")
    expect(membership).to have(1).errors_on(:username)
  end

  it "is valid without a first name on create" do
    membership = FactoryGirl.build(:membership, firstname: "")
    expect(membership).to have(0).errors_on(:firstname)
  end

  it "is invalid without a first name on update" do
    membership = FactoryGirl.create(:membership, firstname: "")
    expect(membership).to have(1).errors_on(:firstname)
  end

  it "is valid without a last name on create" do
    membership = FactoryGirl.build(:membership, lastname: "")
    expect(membership).to have(0).errors_on(:lastname)
  end

  it "is invalid without a last name on update" do
    membership = FactoryGirl.create(:membership, lastname: "")
    expect(membership).to have(1).errors_on(:lastname)
  end



end
