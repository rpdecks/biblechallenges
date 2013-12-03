require 'spec_helper'

describe Challenge do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:challenge)).to be_valid
    end

    it { should validate_presence_of(:begindate) }
    it { should validate_presence_of(:enddate) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:owner_id) }
    it { should validate_presence_of(:subdomain) }
    it do # This has to be written different. Check https://github.com/thoughtbot/shoulda-matchers#validate_uniqueness_of
      create(:challenge)
      should validate_uniqueness_of(:subdomain)
    end

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

      it "infers based on chapterstoread" do
        challenge.enddate = nil
        challenge.chapterstoread = 'Matt 20-28'
        challenge.save
        expect(challenge.enddate).to eql(challenge.begindate + 8.days)
      end

    end

    context 'when the challenge is active' do
      let (:challenge) {create(:challenge)}

      before do
        challenge.active =  true
        challenge.save
      end

      it "doesn't allow begindate to be chaned" do
        expect(challenge.update_attributes({begindate: Date.today + 10.days})).to be_false
        expect(challenge.errors.messages[:change_not_allowed]).to include("because this challenge is active")        
      end
      it "doesn't allow enddate to be chaned" do
        expect(challenge.update_attributes({enddate: Date.today - 10.days})).to be_false
        expect(challenge.errors.messages[:change_not_allowed]).to include("because this challenge is active")        
      end
      it "doesn't allow chapterstoread to be chaned" do
        expect(challenge.update_attributes({chapterstoread: 'Phil 1 - 2'})).to be_false
        expect(challenge.errors.messages[:change_not_allowed]).to include("because this challenge is active")  
      end
    end


  end

  describe "Relations" do
    it { should belong_to(:owner) }
    it { should have_many(:memberships) }
    it { should have_many(:members).through(:memberships)}
    it { should have_many(:readings) }
  end

  describe 'Callbacks' do
    describe 'After save' do
      describe '#generate_readings' do
        let(:challenge){create(:challenge, chapterstoread: 'Matt 20-22')}
        
        context 'when the challenge is being created' do

          it 'creates a reading for every chapter assigned in the challenge'do
            expect(challenge.readings.length).to eql 3
          end

          it 'creates the readings with its corresponding date' do
            challenge.readings.each_with_index do |reading,index|
              expect(reading.date.strftime("%a, %-d %b %Y")).to eql((challenge.begindate + index.day).strftime("%a, %-d %b %Y"))
            end
            expect(challenge.readings.last.date.strftime("%a, %-d %b %Y")).to eql(challenge.enddate.strftime("%a, %-d %b %Y"))          
          end

        end

        context "when the challenge isn't active" do
          context "when 'begindate' has changed" do

            before do
              # challenge.chapterstoread = 'Phile'
              challenge.begindate = Date.today + 7.days
              challenge.save
            end

            it 're-creates a reading for every chapter assigned in the challenge'do
              expect(challenge.readings.length).to eql 3
            end

            it 're-creates the readings with its corresponding date' do
              challenge.readings.each_with_index do |reading,index|
                expect(reading.date.strftime("%a, %-d %b %Y")).to eql((challenge.begindate + index.day).strftime("%a, %-d %b %Y"))
              end
              expect(challenge.readings.last.date.strftime("%a, %-d %b %Y")).to eql(challenge.enddate.strftime("%a, %-d %b %Y"))          
            end

          end

          context "when 'chapterstoread' has changed" do

            before do
              challenge.chapterstoread = 'Phil 1 - 4'
              challenge.save
            end

            it 're-creates a reading for every chapter assigned in the challenge'do
              expect(challenge.readings.length).to eql 4
            end

            it 're-creates the readings with its corresponding date' do
              challenge.readings.each_with_index do |reading,index|
                expect(reading.date.strftime("%a, %-d %b %Y")).to eql((challenge.begindate + index.day).strftime("%a, %-d %b %Y"))
              end
              expect(challenge.readings.last.date.strftime("%a, %-d %b %Y")).to eql(challenge.enddate.strftime("%a, %-d %b %Y"))          
            end

          end
        end
      end
    end
  end

  describe "Class methods" do

  end

  describe 'Instance methods' do

    let(:challenge){create(:challenge)}

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

    describe '#has_member?' do
      let(:user){create(:user)}
      context 'when the user has already joined the challenge' do
        before {challenge.join_new_member(user)}
        it 'returns true' do
          expect(challenge.has_member?(user)).to be_true
        end
      end
      context "when the user hasn't already joined the challenge" do
        it 'returns false' do
          expect(challenge.has_member?(user)).to be_false
        end
      end
    end    

  end
end
