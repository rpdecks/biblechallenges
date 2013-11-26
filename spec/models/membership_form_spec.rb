require 'spec_helper'

describe MembershipForm do

  describe "Validations" do

    it { should validate_presence_of(:email) }
    
  end

  describe '#subscribe' do
    
    context 'when the email belongs to an user already registered' do
      let(:challenge)   {create(:challenge)}
      let(:user)        {create(:user)}
      let!(:membership) {challenge.join_new_member(user)}

      let(:membership) {build(:membership_form, email: user.email)}

      it "finds the current_user membership" do
        membership.subscribe
        expect(membership.user).to eql(user)
      end

    end

  end

end