require 'spec_helper'

describe MembershipsController do

  let(:owner){create(:user)}
  let(:challenge){create(:challenge, owner: owner)}
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}

  before do
    @request.host = "#{challenge.subdomain}.test.com"
  end

  describe "Routing" do
    let(:subdomainurl) { "http://#{challenge.subdomain}.test.com" }
    hash = 'somehash'

    it {expect({get: "challenges/#{challenge.id}/memberships/"}).to route_to(controller: "memberships", action: "index", challenge_id: "#{challenge.id}")}
    it {expect({get: "#{subdomainurl}/unsubscribe/#{hash}"}).to route_to(controller: 'memberships', action: 'unsubscribe_from_email', hash: hash)}
    it {expect({delete: "#{subdomainurl}/unsubscribe/#{hash}"}).to route_to(controller: 'memberships', action: 'destroy', hash: hash)}    
  end

  describe 'GET#unsubscribe_from_email' do
    context 'with a valid hash' do
      it "renders the :unsubscribe template" do
        hash = membership.hash_for_url
        get :unsubscribe_from_email, hash: hash
        expect(response).to render_template(:unsubscribe_from_email)
      end

      it "renders with email layout" do
        hash = membership.hash_for_url
        get :unsubscribe_from_email, hash: hash
       should render_with_layout('from_email')
      end

      it "finds the membership" do
        hash = membership.hash_for_url
        get :unsubscribe_from_email, hash: hash
        expect(assigns(:membership)).to eql(membership)
      end
    end

    context 'with an invalid hash' do
      let(:hash){'gB0NV05e'}

      it "renders the :new template" do
        get :unsubscribe_from_email, hash: hash
        expect(response).to render_template(:unsubscribe_from_email)
      end

      it "renders with email layout" do
        get :unsubscribe_from_email, hash: hash
        should render_with_layout('from_email')
      end

      it 'sets a proper flash message' do
        get :unsubscribe_from_email, hash: hash
        should set_the_flash[:error].to("This unsubscribe link doesn't exist")
      end
    end

  end

  describe 'Guest access' do

    describe 'GET#index' do
      it "redirects to the root" do
        get :index
        expect(response).to redirect_to new_user_session_url
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

      describe 'DELETE#destroy' do

        it "finds the current_user membership" do
          delete :destroy, challenge_id: challenge, id: membership
          expect(assigns(:membership)).to eql(membership)
        end

        it "destroys the membership" do
          expect{
            delete :destroy, challenge_id: challenge, id: membership
          }.to change(Membership,:count).by(-1)
        end

        it "redirects to the challenge url" do
          delete :destroy, challenge_id: challenge, id: membership
          expect(response).to redirect_to root_url(subdomain:challenge.subdomain)
        end
        
      end

    end
  end

  describe 'Owner challenge access' do
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
