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
    it { should belong_to(:group) }
    it { should have_many(:readings).through(:membership_readings) }
    it { should have_many(:membership_readings) }
  end

  describe "Class methods" do
  end

  describe 'Instance methods' do
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
        challenge.generate_readings
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

      describe '#send_todays_reading' do
        it "sends todays reading after creation if it exists" do
          pending
          user = create(:user)
          challenge = create(:challenge, begindate: Date.today)  
          membership = build(:membership, challenge: challenge, user: user)
          #MembershipReadingMailer.should_receive(:daily_reading_email).and_return(double("MembershipReadingMailer", deliver: true))  #params?
          expect(MembershipReadingMailer).to receive(:daily_reading_email).and_return(double("MembershipReadingMailer", deliver: true))  #params?
          membership.save
        end
        it "does not send todays reading after creation if it does not exist" do
          user = create(:user)
          challenge = create(:challenge, begindate: Date.tomorrow) 
          membership = build(:membership, challenge: challenge, user: user)
          MembershipReadingMailer.should_not_receive(:daily_reading_email)
          membership.save
        end
      end

    end
  end

end
