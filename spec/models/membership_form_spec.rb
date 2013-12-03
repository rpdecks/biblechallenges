require 'spec_helper'

describe MembershipForm do

  describe "Validations" do

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:challenge) }
    
  end

  describe '#subscribe' do
    let!(:challenge)   {create(:challenge)}

    context 'when the email belongs to an user already registered' do
      let(:user)        {create(:user)}
      let(:membership_form) {build(:membership_form, email: user.email, challenge: challenge)}

      it "creates the membership" do
        expect {
          membership_form.subscribe
        }.to change(Membership,:count).by(1)
      end

      it "finds the current_user membership" do
        membership_form.subscribe
        expect(membership_form.user).to eql(user)
      end

      context 'with a membership already created' do
        let!(:membership){challenge.join_new_member(user)}

        it "doesn't create the membership" do
          expect {
            membership_form.subscribe
          }.to change(Membership,:count).by(0)
        end        

        it "finds the current_user membership" do
          membership_form.subscribe
          expect(membership_form.user).to eql(user)
        end

        it 'sets the proper error message' do
          membership_form.subscribe
          expect(membership_form.errors.messages[:email]).to include ("already registered in this challenge")
        end

      end

    end

    context 'when the email belongs to a new user' do
      let(:email){'super_new_email@test.com'}
      let!(:membership_form) {build(:membership_form, email: email, challenge: challenge)}

      it "creates a new User" do
        membership_form.subscribe
        expect(membership_form.user.email).to eql(email)
      end

      it "creates the membership" do
        expect {
          membership_form.subscribe
        }.to change(Membership,:count).by(1)
      end

    end


  end

end