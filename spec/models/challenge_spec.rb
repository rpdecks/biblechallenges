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
        let (:challenge) {build(:challenge, enddate: Time.now, begindate: Time.now + 1.day)}

        it "doesn't validate the challenge" do
          expect(challenge.valid?).to be false
          expect(challenge.errors.messages[:enddate]).to include ("The challenge begin and end dates must be sequential")
        end
      end

      context 'when end date is greater then begin date' do
        let (:challenge) {build(:challenge, enddate: Time.now + 1.day, begindate: Time.now)}

        it "validates the challenge" do
          expect(challenge.valid?).to be true
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
