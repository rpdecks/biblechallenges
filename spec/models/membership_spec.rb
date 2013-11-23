require 'spec_helper'

describe Membership do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:membership)).to be_valid
    end

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:challenge_id) }
    it { should validate_presence_of(:bible_version) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:challenge_id) }

    it "is invalid without an email" do
      membership = build(:membership, email: "")
      expect(membership).to have(1).errors_on(:email)
    end

    it "is invalid without a challenge_id" do
      membership = build(:membership, challenge_id: nil)
      expect(membership).to have(1).errors_on(:challenge_id)
    end

    context 'when updating' do
      
      it "is invalid without a user name" do
        membership = create(:membership, username: "")
        expect(membership).to have(1).errors_on(:username)
      end

      it "is invalid without a first name" do
        membership = create(:membership, firstname: "")
        expect(membership).to have(1).errors_on(:firstname)
      end

      it "is invalid without a last name" do
        membership = create(:membership, lastname: "")
        expect(membership).to have(1).errors_on(:lastname)
      end

    end

    context 'when creating' do

      it "is valid without a user name" do
        membership = build(:membership, username: "")
        expect(membership).to have(0).errors_on(:username)
      end

      it "is valid without a first name" do
        membership = build(:membership, firstname: "")
        expect(membership).to have(0).errors_on(:firstname)
      end

      it "is valid without a last name" do
        membership = build(:membership, lastname: "")
        expect(membership).to have(0).errors_on(:lastname)
      end

    end

    context 'when a user has already joined a challenge' do
      let(:user){create(:user)}
      let(:challenge){create(:challenge)}
      let!(:membership){create(:membership, challenge: challenge, user: user)}

      it 'does not allow to re-join again' do
        expect(build(:membership, challenge: challenge, user: user)).to_not be_valid
      end

    end


  end

  describe "Relations" do
    it { should belong_to(:user) }
    it { should belong_to(:challenge) }
  end

end