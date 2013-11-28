require 'spec_helper'

describe Membership do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:membership)).to be_valid
    end

    it { should validate_presence_of(:challenge_id) }
    it { should validate_presence_of(:bible_version) }
    it { should ensure_inclusion_of(:bible_version).in_array(Membership::BIBLE_VERSIONS)}
    it do # This has to be written different. Check https://github.com/thoughtbot/shoulda-matchers#validate_uniqueness_of
      create(:membership)
      should validate_uniqueness_of(:user_id).scoped_to(:challenge_id)
    end

    it "is invalid without a challenge_id" do
      membership = build(:membership, challenge_id: nil)
      expect(membership).to have(1).errors_on(:challenge_id)
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
    it { should have_many(:readings).through(:membership_readings) }
    it { should have_many(:membership_readings) }    
  end

  describe 'Callbacks' do
    describe 'After create' do
      describe '#associate_readings' do
        let(:membership){create(:membership)}

        it 'associates all the readings from its challenge' do
          expect(membership.readings).to match_array(membership.challenge.readings)
        end

      end
    end
  end

end