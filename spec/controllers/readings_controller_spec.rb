require 'spec_helper'

describe ReadingsController do

  let(:owner){create(:user)}
  let(:challenge){create(:challenge_with_readings, owner: owner)}
  let(:user){create(:user)}
  let!(:membership){create(:membership, challenge: challenge, user: user)}
  let(:membership_reading){membership.membership_readings.first}
  let(:hash){membership_reading.hash_for_url}


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

  describe "Owner Access" do
    before do
      sign_in :user, owner
    end

    describe "GET #edit" do
      it "assigns @reading" do
        reading = challenge.readings.first
        get :edit, id: reading
        expect(assigns(:reading)).to eql reading
      end
      it "renders the :edit template" do
        reading = challenge.readings.first
        get :edit, id: reading
        expect(response).to render_template(:edit)
      end
    end
    describe "PUT#update" do
      context "with valid attributes" do
        it "updates the reading in the database" do
          reading = challenge.readings.first
          put :update, id: reading, reading: attributes_for(:reading, discussion: "Who is God?")
          reading.reload
          expect(reading.discussion).to eql "Who is God?"
        end
      end
    end
  end



  describe "User Access" do
    before do
      sign_in :user, user
    end

    describe "GET #edit" do
      it "does not show the edit form"
    end
    describe "GET #show" do
      context "the user is part of this challenge and reading" do
        it "assigns the requested reading to @reading" do
          reading = challenge.readings.first
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


        it "does not render the show template" do
          randomreading = create(:reading)
          get :show, id: randomreading
          expect(response).to_not render_template :show
        end

        it "redirects to / " do
          randomreading = create(:reading)
          get :show, id: randomreading
          expect(response).to redirect_to root_url
        end

      end

    end
  end
end
