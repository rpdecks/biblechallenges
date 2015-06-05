require 'spec_helper'

describe Challenge do

  describe "Validations" do
    it "has a valid factory" do
      expect(create(:challenge)).to be_valid
    end
    it { should validate_presence_of(:begindate) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:owner_id) }


    describe 'End date and begin date validation' do

      context 'when begin date is greater than end date' do
        let (:challenge) {build(:challenge, enddate: Date.today, begindate: Date.today + 1.day)}

        it "doesn't validate the challenge" do
          expect(challenge.valid?).to be false
          expect(challenge.errors.messages[:begin_date]).to include ("and end date must be sequential")
        end
      end

      context 'when end date is greater then begin date' do
        let (:challenge) {build(:challenge, enddate: Date.today + 1.day, begindate: Date.today)}

        it "validates the challenge" do
          expect(challenge.valid?).to be true
        end
      end

      context 'when begin date is earlier than today' do
        let (:challenge) {build(:challenge, enddate: Date.today + 1.day, begindate: Date.today - 1.day)}

        it "doesn't validate the challenge" do
          expect(challenge.valid?).to be false
          expect(challenge.errors.messages[:begin_date]).to include ("cannot be earlier than today")
        end
      end

    end

    context 'when end date is not provided' do
      let (:challenge) {build(:challenge)}

      it "infers based on chapters_to_read" do
        challenge.enddate = nil
        challenge.chapters_to_read = 'Matt 20-28'
        challenge.save
        expect(challenge.enddate).to eql(challenge.begindate + 8.days)
      end

    end


  end

  describe "Relations" do
    it { should belong_to(:owner) }
    it { should have_many(:memberships) }
    it { should have_many(:members).through(:memberships)}
    it { should have_many(:readings) }
    it { should have_many(:membership_readings) }
  end



  describe 'Instance methods' do

    let(:challenge){create(:challenge)}

    describe '#generate_readings' do
      let(:challenge){create(:challenge, chapters_to_read: 'Matt 20-22, Psalm 8-10')}
      let(:expected_readings) { 6 } # avoiding magic numbers

      context 'when the challenge is being created' do

        it 'creates a reading for every chapter assigned in the challenge'do
          challenge.generate_readings
          
          expect(challenge.readings.length).to eql 6
        end

        it 'creates the readings with its corresponding date' do
          challenge.generate_readings
          challenge.readings.each_with_index do |reading,index|
            expect(reading.date.strftime("%a, %-d %b %Y")).to eql((challenge.begindate + index.day).strftime("%a, %-d %b %Y"))
          end
          expect(challenge.readings.last.date.strftime("%a, %-d %b %Y")).to eql(challenge.enddate.strftime("%a, %-d %b %Y"))
        end

      end

    end

    describe '#membership_for' do
      let(:user){create(:user)}
      context 'when the user has already joined the challenge' do
        let!(:membership){challenge.join_new_member(user)}
        it 'returns the membership' do
          expect(challenge.reload.membership_for(user)).to eql(membership)
        end
      end
      context "when the user hasn't already joined the challenge" do
        it 'returns nil' do
          expect(challenge.membership_for(user)).to be_nil
        end
      end
    end

    describe '#progress_percentage' do
      context 'when the user has already joined the challenge' do
        it "returns of the percentage of the challenge completed according to schedule" do
        challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1-20", begindate: "2050-01-01")
        Timecop.travel("2050-01-05")
        expect(challenge.percentage_completed).to eq 25
        Timecop.return
        end
      end
    end

    describe '#join_new_member' do
      context 'with one user' do
        let(:user){create(:user)}
        it 'creates the membership for that user' do
          expect {
            challenge.join_new_member(user)
          }.to change(challenge.memberships, :count).by(1)
        end
        it 'creates a membership for that user specifying the bible version' do
          expect {
            challenge.join_new_member(user,{bible_version: 'NASB'})
          }.to change(challenge.memberships, :count).by(1)
          expect(challenge.memberships.last.bible_version).to eql 'NASB'
        end
      end
      context 'with multiple users' do
        let(:users){create_list(:user, 3)}
        it 'creates the memberships for that users' do
          expect {
            challenge.join_new_member(users)
          }.to change(challenge.memberships, :count).by(3)
        end
      end
    end

    describe '#has_ungrouped_member?' do
      it 'returns true if the user is in this challenge but not in a group' do
        user = create(:user)
        create(:membership, user: user, challenge: challenge)
        expect(challenge.has_ungrouped_member?(user)).to be_truthy
      end
    end
    describe '#has_grouped_member?' do
      it 'returns true if the user is in a group in this challenge' do
        user = create(:user)
        group = create(:group, challenge: challenge, user: create(:user))
        create(:membership, user: user, challenge: challenge, group: group)
        expect(challenge.has_grouped_member?(user)).to be_truthy
      end
    end
    describe '#has_member?' do
      let(:user){create(:user)}
      context 'when the user has already joined the challenge' do
        before {challenge.join_new_member(user)}
        it 'returns true' do
          expect(challenge.has_member?(user)).to be_truthy
        end
      end
      context "when the user hasn't already joined the challenge" do
        it 'returns false' do
          expect(challenge.has_member?(user)).to be_falsey
        end
      end
    end
  end
  describe "Search scopes" do
    it "#search_by_name should not find a challenge when searching by name" do
      challenge = create(:challenge, name: "Guy Challenge")
      expect(Challenge.search_by_name('Phil')).not_to include [challenge]
    end
    it "#search_by_name should find a challenge when searching by name" do
      challenge = create(:challenge, name: "Guy Challenge")
      expect(Challenge.search_by_name('Guy')).to match_array [challenge]
    end
  end
end
