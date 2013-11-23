require 'spec_helper'

describe MembershipsController do

  let(:owner){create(:user)}
  let(:challenge){create(:challenge, owner: owner)}
  before do
    @request.host = "#{challenge.subdomain}.test.com"
  end

  describe "Routing" do
    it { { get: "challenges/#{challenge.id}/memberships/"}.should route_to(controller: "memberships", action: "index", challenge_id: "#{challenge.id}") }
  end

  describe 'Guest access' do

    describe 'GET#index' do
      it "redirects to the root" do
        get :index
        expect(response).to redirect_to root_url(subdomain:false)
      end
    end


    describe 'GET#show (my-membership)' do
      it "redirects to the challenge" do
        get :show
        expect(response).to redirect_to root_url(subdomain:challenge.subdomain)
      end
    end
  end

  describe 'User access' do

    let(:current_user) {create(:user)}
    before{sign_in :user, current_user}

    describe 'GET#index' do
      it "redirects to the root" do
        get :index
        expect(response).to redirect_to root_url(subdomain:false)
      end
    end

    describe 'GET#show  (my-membership)' do
      it "redirects to the challenge" do
        get :show
        expect(response).to redirect_to root_url(subdomain:challenge.subdomain)
      end
    end


    context 'when the user has already joined' do
      let!(:membership){challenge.join_new_member(current_user)}
      describe 'GET#show  (my-membership)' do
        it "finds the current_user membership" do
          get :show 
          expect(assigns(:membership)).to eql(membership)
        end

        it "renders the :show template" do
          get :show
          expect(response).to render_template :show
        end
      end
      
    end
  end

  describe 'Owenr challenge access' do
    before{sign_in :user, owner}
    describe 'GET#index' do
      it "collects memberships into @memberships" do
        get :index
        expect(assigns(:memberships)).to match_array(challenge.memberships)
      end

      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end


  end
end


# describe MembershipsController, "Actions as a logged in user" do

#   context "on GET to #index" do
#     it "should render the index template" do
#       get :index 
#       should render_template("memberships/index")
#     end

#     it "assigns the current user's memberships" do
#       FactoryGirl.create(:membership, user: current_user)
#       get :index
#       assigns(:memberships).should_not be_nil
#     end
#   end

#   context "on GET to #show" do

#     it "should render the show template " do
#       membership = FactoryGirl.create(:membership, user: current_user)
#       get :show, id: membership
#       should render_template("memberships/show")
#     end

#     it "assigns the identified membership" do
#       membership = FactoryGirl.create(:membership, user: current_user)
#       get :show, id: membership
#       assigns(:membership).should_not be_nil
#     end

#   end

# end
