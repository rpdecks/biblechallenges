require 'spec_helper'

describe ReadingsController do

  let(:challenge){create(:challenge, chapters_to_read:'matt 1-4')}
  let(:user){create(:user)}
  let(:membership){create(:membership, challenge: challenge, user: user)}
  let(:membership_reading){membership.membership_readings.first}
  let(:hash){membership_reading.hash_for_url}

  before do
    @request.host = "#{challenge.subdomain}.test.com"
  end

  describe "for a guest" do
    describe "GET #show" do
      it "redirects to login" do
        reading = challenge.readings.first
        get :show, id: reading
        expect(response).to redirect_to new_user_session_url
      end
      it "does not assign requested reading to @reading" do
        reading = challenge.readings.first
        get :show, id: reading
        expect(assigns(:reading)).to_not eq reading
      end
    end
  end

  describe "User Access" do
    before do
      sign_in :user, user
    end

    describe "GET #show" do
      context "the user is part of this challenge and reading" do
        it "assigns the requested reading to @reading" do
          reading = challenge.readings.first
          binding.pry
          get :show, id: reading
          expect(assigns(:reading)).to eq reading
        end

        it "renders the show template" do
          reading = challenge.readings.first
          get :show, id: reading
          expect(response).to render_template :show
        end
      end

      context "the user is not part of this challenge and reading" do
        it "does not assign the requested reading to @reading" do
          randomreading = create(:reading)
          get :show, id: randomreading
          expect(assigns(:reading)).to_not eq randomreading
        end


        it "does not render the show template"
        it "redirects to / "

      end

    end
  end
end
