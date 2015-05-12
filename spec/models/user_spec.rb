require 'spec_helper'

describe User do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:user)).to be_valid
    end


    # context 'when updating' do
      
    #   it "is invalid without a user name" do
    #     membership = create(:membership, username: "")
    #     expect(membership).to have(1).errors_on(:username)
    #   end

    #   it "is invalid without a first name" do
    #     membership = create(:membership, firstname: "")
    #     expect(membership).to have(1).errors_on(:firstname)
    #   end

    #   it "is invalid without a last name" do
    #     membership = create(:membership, lastname: "")
    #     expect(membership).to have(1).errors_on(:lastname)
    #   end

    # end


  end

  describe "Relations" do
    it { should have_many(:created_challenges) }
    it { should have_many(:memberships) }
    it { should have_many(:comments) }
    it { should have_many(:badges) }
    it { should have_many(:challenges).through(:memberships)}
    it { should have_many(:groups).through(:memberships)}
  end

  describe "Callbacks" do
    it "should create a profile record after being created" do
      expect{FactoryGirl.create(:user)}.to change(Profile, :count).by(1)
    end

    it "deletes the user profile on user deletion" do
      current_user = FactoryGirl.create(:user)
      expect { current_user.destroy }.to change(Profile, :count).by(-1)
    end
  end

end
