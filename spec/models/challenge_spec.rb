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
    it { should validate_uniqueness_of(:subdomain) }

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

  end

  describe "Relations" do
    it { should belong_to(:owner) }
    it { should have_many(:memberships) }
    it { should have_many(:members).through(:memberships)}
    it { should have_many(:readings) }
  end
end
