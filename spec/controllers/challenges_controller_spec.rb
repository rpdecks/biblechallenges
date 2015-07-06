require 'spec_helper'

describe ChallengesController, "Routing" do
  it { expect({get: "/"}).to route_to(controller: "challenges", action: "index") }
end

describe ChallengesController, "Actions" do
  context "on GET to #index as a visitor" do
    it "loads public challenges" do
      get :index
      expect(assigns(:public_challenges)).not_to be_nil
    end
  end

  context "GET #show" do
    it "renders show template if user is not a member of this challenge", skip: true do
      pending
      challenge = create(:challenge)
      get :show, id: challenge
      expect(response).to render_template(:show)
    end

    it "redirects to member/challenges#show if the user is a member of this challenge" do
      user = create(:user)
      challenge = create(:challenge)
      create(:membership, challenge: challenge, user: user)
      sign_in :user, user

      get :show, id: challenge
      expect(response).to redirect_to member_challenge_path(challenge)
    end
  end
end
