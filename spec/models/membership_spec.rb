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

  describe "Class methods" do
  end

  describe 'Instance methods' do
    describe '#overall_progress_percentage' do
      let!(:challenge){create(:challenge, chapters_to_read: 'Mar 1 -7')}
      let(:membership){create(:membership, challenge: challenge)}

      before do
        membership.membership_readings[0..3].each do |mr|
          mr.state = 'read'
          mr.save!
        end
      end

      it 'returns the progress percentage based on readings' do
        expect(membership.overall_progress_percentage).to eql(57)
      end
    end
    describe '#to_date_progress_percentage' do
      let!(:challenge){create(:challenge, chapters_to_read: 'Mar 1 -7')}
      let(:membership){create(:membership, challenge: challenge)}
      before do
        membership.membership_readings[0..1].each do |mr| # read first two
          mr.state = 'read'
          mr.save!
        end
      end
      it 'returns the progress percentage of the readings up to and including the passed in date' do
        # total of four days elapsed with two readings completed
        expect(membership.to_date_progress_percentage(challenge.begindate + 3.days)).to eql(50)
      end
    end

    describe '#completed?' do
      it "returns true if all the chapters have been read" do
        challenge = create(:challenge, chapters_to_read: 'Mar 1 -2')
        membership = create(:membership, challenge: challenge)
        membership.membership_readings[0..1].each do |mr| # read first two
          mr.state = 'read'
          mr.save!
        end
        expect(membership.completed?).to eq true
      end
      it "returns false if not all the chapters have been read" do
        challenge = create(:challenge, chapters_to_read: 'Mar 1-3')
        membership = create(:membership, challenge: challenge)
        membership.membership_readings[0..1].each do |mr| # read first two
          mr.state = 'read'
          mr.save!
        end
        expect(membership.completed?).to eq false
      end
    end


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
