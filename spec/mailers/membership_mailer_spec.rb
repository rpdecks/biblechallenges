require "spec_helper"

describe MembershipMailer do
  describe '.creation_email' do

    let(:user){create(:user, :with_profile)}
    let(:challenge){create(:challenge)}
    let!(:membership){challenge.join_new_member(user)}

    it "sends a successful creation email" do
      expect{ MembershipMailer.creation_email(membership).deliver_now }.to_not raise_error
    end

    it "sends the email to the user's email" do
      pending
      successful_creation_email = ActionMailer::Base.deliveries.last
      expect(successful_creation_email.to).to match_array [user.email]
    end

  end



end
