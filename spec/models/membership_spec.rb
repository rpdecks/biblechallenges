require 'spec_helper'
include ActionView::Helpers::DateHelper

describe Membership do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:membership)).to be_valid
    end

    it { should validate_presence_of(:challenge_id) }
    it { should validate_presence_of(:user_id) }
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
    it { should have_many(:readings).through(:challenge) }
    it { should have_many(:membership_readings) }
  end

  describe 'Instance methods' do
    describe "#associate_statistics" do
      it "creates named statistics and associates them with new membership" do
        challenge = create(:challenge)
        membership = create(:membership, challenge: challenge)

        membership.associate_statistics

        # somehow verify that all the statistics are present
        MembershipStatistic.descendants.each do |mem_stat|
          #mem_stat.name will hold the type of each possible membership statistic
          result = membership.membership_statistics.find_by_type(mem_stat.name)
          expect(result).to_not be_nil
        end
      end
    end

    describe '#completed?' do
      it "returns true if all the chapters have been read" do
        challenge = create(:challenge, chapters_to_read: 'Mar 1 -2')
        membership = create(:membership, challenge: challenge)
        membership.readings[0..1].each do |r| # read first two
          create(:membership_reading, reading: r, membership: membership)
        end
        expect(membership.completed?).to eq true
      end
      it "returns false if not all the chapters have been read" do
        challenge = create(:challenge, chapters_to_read: 'Mar 1-3')
        challenge.generate_readings
        membership = create(:membership, challenge: challenge)
        membership.readings[0..1].each do |r| # read first two
          create(:membership_reading, reading: r, membership: membership)
        end
        expect(membership.completed?).to eq false
      end
    end

    describe '#last_recorded_reading_time' do
      it "returns the time of most recent recorded reading" do
        membership = create(:membership)
        newest_reading = create(:membership_reading, membership: membership)
        create(:membership_reading, membership: membership, created_at: 3.days.ago)

        result = membership.last_recorded_reading_time
        expect(result).to eq time_ago_in_words(newest_reading.created_at) + " ago"
      end

      it "returns the no reading text when there is no reading" do
        membership = create(:membership)

        result = membership.last_recorded_reading_time
        expect(result).to eq MembershipReading::NO_READING
      end
    end

    describe '#last_recorded_chapter' do
      it "returns the most recnet book and chapter of the membership reading" do
        membership = create(:membership)
        newest_reading = create(:membership_reading, membership: membership)
        create(:membership_reading, membership: membership, created_at: 3.days.ago)

        result = membership.last_recorded_chapter
        expect(result).to eq newest_reading.chapter_name
      end
    end
  end
end
