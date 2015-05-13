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
    describe '#overall_progress_percentage' do
      let!(:challenge){create(:challenge, chapters_to_read: 'Mar 1 -7')}
      let(:membership){create(:membership, challenge: challenge)}

      before do
        challenge.generate_readings
        membership.membership_readings[0..3].each do |mr|
          mr.state = 'read'
          mr.save!
        end
      end

      it 'returns the progress percentage based on readings' do
        expect(membership.overall_progress_percentage).to eql(57)
      end
      it 'returns the progress percentage from the associated stat model based on readings' do
        membership.associate_statistics
        membership.membership_statistics.each {|m| m.update}
        expect(membership.membership_statistics.first.value.to_i).to eql(57)
      end
    end
    describe '#to_date_progress_percentage' do
      let!(:challenge){create(:challenge, chapters_to_read: 'Mar 1 -7')}
      let(:membership){create(:membership, challenge: challenge)}
      before do
        challenge.generate_readings
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

    describe '#punctual_reading_percentage' do
      it "returns the percentage of time the reader performs the reading according to schedule" do
        Timecop.travel(4.days.ago)
        challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
        membership = create(:membership, challenge: challenge)
        membership.membership_readings[0..1].each do |mr| # read first two
          mr.state = 'read'
          mr.save!
        end
        Timecop.return
        Timecop.travel(1.days.ago)
        membership.membership_readings.third.update_attributes(state: "read")
        Timecop.return
        expect(membership.punctual_reading_percentage).to eq 25
      end
    end

    describe '#calculate_record_sequential_reading_count' do
      it "returns the percentage of time the reader performs the reading according to schedule" do
        Timecop.travel(6.days.ago)
        challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
        membership = create(:membership, challenge: challenge)
        membership.membership_readings[0..1].each do |mr| # read first two
          mr.state = 'read'
          mr.save!
        end
        Timecop.return
        Timecop.travel(3.days.ago)
        membership.membership_readings[2].update_attributes(state: "read")
        Timecop.return
        Timecop.travel(2.days.ago)
        membership.membership_readings[3].update_attributes(state: "read")
        Timecop.return
        membership.membership_readings[4].update_attributes(state: "read")
        membership.membership_readings[5].update_attributes(state: "read")

        expect(membership.rec_sequential_reading_count).to eq 2
      end
    end

    describe '#calculate_record_sequential_reading_count' do
      it "will recalcuate the group sequential reading and punctual reading percentage averages" do
        Timecop.travel(6.days.ago)
        challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
        group = challenge.groups.create(name: "UC Irvine", user_id: User.first.id)
        membership = create(:membership, challenge: challenge)
        membership2 = create(:membership, challenge: challenge, user: User.first)
        membership.update_attributes(group_id: group.id)
        membership2.update_attributes(group_id: group.id)

        membership.membership_readings[0..1].each do |mr| # read first two
          mr.state = 'read'
          mr.save!
        end
        membership2.membership_readings[0].update_attributes(state: "read")
        Timecop.return
        Timecop.travel(4.days.ago)
        membership2.membership_readings[1].update_attributes(state: "read")
        Timecop.return
        Timecop.travel(3.days.ago)
        membership.membership_readings[2].update_attributes(state: "read")
        membership2.membership_readings[2].update_attributes(state: "read")
        Timecop.return
        Timecop.travel(2.days.ago)
        membership.membership_readings[3].update_attributes(state: "read")
        membership2.membership_readings[3].update_attributes(state: "read")
        Timecop.return
        Timecop.travel(1.days.ago)
        membership2.membership_readings[4].update_attributes(state: "read")
        Timecop.return
        membership.membership_readings[4].update_attributes(state: "read")
        membership.membership_readings[5].update_attributes(state: "read")
        membership2.membership_readings[5].update_attributes(state: "read")

        expect(membership.rec_sequential_reading_count).to eq 2
        expect(membership2.rec_sequential_reading_count).to eq 5
        expect(membership2.punctual_reading_percentage).to eq 83
        expect(membership.punctual_reading_percentage).to eq 50
        expect(group.reload.ave_progress_percentage).to eq 30
        expect(group.reload.ave_punctual_reading_percentage).to eq 66
        expect(group.reload.ave_sequential_reading_count).to eq 3
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
