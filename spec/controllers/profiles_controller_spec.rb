require 'spec_helper' 
describe ProfilesController do

  describe "Routing" do
    it { expect({get: '/profile/edit'}).to route_to(controller: 'profiles', action: 'edit') }
    it { expect({put: '/profile'}).to route_to(controller: 'profiles', action: 'update') }
  end


  context "User Access" do

    describe "GET#edit" do
      it "assigns the current user's profile to @profile" do
        current_user = create(:user)
        sign_in :user, current_user
        get :edit
        expect(assigns(:profile)).to eql(current_user.profile)
      end

      it "renders the :edit template" do
        current_user = create(:user)
        sign_in :user, current_user
        get :edit
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT#update" do
      context "with valid attributes" do
        it "updates the profile in the database" do
          current_user = create(:user)
          sign_in :user, current_user
          put :update, profile: attributes_for(:profile, first_name: "Phil",
                                               last_name: "Bradley",
                                               username: "yeahbuddy")
          current_user.reload
          expect(current_user.profile.first_name).to eql "Phil"
        end
      end

        it "renders the profile edit page" do
          current_user = create(:user)
          sign_in :user, current_user
          put :update, profile: attributes_for(:profile, first_name: "Phil",
                                               last_name: "Bradley",
                                               username: "yeahbuddy")
          expect(response).to render_template(:edit)
        end
      end

  end
    

end
