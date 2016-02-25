require 'spec_helper'

describe Member::MembershipsController do
  let(:owner){create(:user)}
  let(:challenge){create(:challenge, :with_membership, owner: owner)}
  let(:user){create(:user)}
  let!(:membership){challenge.join_new_member(user)}

  before(:each) do
    sign_in :user, user
  end

  describe 'DELETE#destroy' do
    it "finds the current_user membership" do
      delete :destroy, id: membership
      expect(assigns(:membership)).to eql(membership)
    end

    it "destroys the membership" do
      expect{
        delete :destroy, id: membership
      }.to change(Membership,:count).by(-1)
    end

    it "redirects to the challenge url" do
      delete :destroy, id: membership
      expect(response).to redirect_to challenge
    end
  end

  describe  'POST#create' do
    let(:newchallenge){create(:challenge_with_readings, :with_membership, owner: owner)}

    it "redirects to the challenge page after joining as a logged in user" do
      somechallenge = create(:challenge)  #uses factorygirl
      post :create, challenge_id: somechallenge.id
      expect(response).to redirect_to [:member, somechallenge]
    end

    it "creates a membership" do
      newchallenge
      expect {
        post :create, challenge_id: newchallenge
      }.to change(Membership, :count).by(1)
    end

    it "associates statistics with membership" do
      ch = newchallenge
      m = ch.memberships.first
      MembershipCompletion.new(m)
      number_of_stats = MembershipStatistic.descendants.size
      expect {
        # this slightly ridiculous expectation is because the stats are created
        # for the challenge creator as well as the new member.  #todo
        post :create, challenge_id: newchallenge
      }.to change(MembershipStatistic, :count).by(number_of_stats)
    end
  end

  describe 'POST#sign_up_via_email' do
    let(:newchallenge){create(:challenge_with_readings, :with_membership, owner: owner)}

    it "creates a membership via email" do
      email = "guy@example.com"
      ch = newchallenge
      membership = ch.memberships.first
      expect {
        post :sign_up_via_email, challenge_id: ch.id, id: membership.id, invite_email: email
      }.to change(Membership, :count).by(1)
      expect(User.last.email).to eq email
    end

    it "does not create a membership via email because of invalid email" do
      email = "invalid@example"
      ch = newchallenge
      membership = ch.memberships.first
      expect {
        post :sign_up_via_email, challenge_id: ch.id, id: membership.id, invite_email: email
      }.to change(Membership, :count).by(0)
    end
  end
end
