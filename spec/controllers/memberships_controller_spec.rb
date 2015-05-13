require 'spec_helper'

describe MembershipsController do

  let(:owner){create(:user)}
  let(:challenge){create(:challenge, owner: owner)}
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}


  describe 'GET#unsubscribe_from_email' do
    context 'with a valid token' do
      it "renders the :unsubscribe template" do
        get :unsubscribe_from_email, id: membership.id
        expect(response).to render_template(:unsubscribe_from_email)
      end

      it "renders with email layout" do
        get :unsubscribe_from_email, id: membership.id
       should render_with_layout('from_email')
      end

      it "finds the membership" do
        get :unsubscribe_from_email, id: membership.id
        expect(assigns(:membership)).to eql(membership)
      end
    end

    context 'with an invalid authtoken' do
      let(:token){'yeahbuddy'}

      it "renders the :new template" do
        pending
        get :unsubscribe_from_email, hash: hash
        expect(response).to render_template(:unsubscribe_from_email)
      end

      it "renders with email layout" do
        pending
        get :unsubscribe_from_email, hash: hash
        should render_with_layout('from_email')
      end

      it 'sets a proper flash message' do
        pending
        get :unsubscribe_from_email, hash: hash
        should set_the_flash[:error].to("This unsubscribe link doesn't exist")
      end
    end

  end

#  describe 'Guest access' do

#    describe 'GET#show (my-membership)' do
#      it "redirects to the challenge" do
#        get :show, challenge_id: challenge.id
#        expect(response).to redirect_to challenge
#      end
#    end
#  end

  describe 'User access' do

    let(:current_user) {create(:user)}
    before{sign_in :user, current_user}

    # not sure what this test does
#    describe 'GET#show  (my-membership)' do
#      it "redirects to the challenge" do
#        get :show, challenge_id: challenge.id
#        expect(response).to redirect_to challenge
#      end
#    end

    describe  'POST#create' do
      let(:newchallenge){create(:challenge, owner: owner)}
      it "redirects to the challenge page after joining as a logged in user" do
        somechallenge = create(:challenge)  #uses factorygirl
        post :create, challenge_id: somechallenge.id
        expect(response).to redirect_to somechallenge
      end

      it "creates a membership" do
        expect {
          post :create, challenge_id: newchallenge
        }.to change(Membership, :count).by(1)

      end
    end

    context 'when the user has already joined' do
      let!(:membership){challenge.join_new_member(current_user)}
      describe 'GET#show  (my-membership)' do
        it "finds the current_user membership" do
          somechallenge = create(:challenge)  #uses factorygirl
          membership = somechallenge.join_new_member(current_user)

          get :show, challenge_id: somechallenge.id

          expect(assigns(:membership)).to eql(membership)
        end

        it "renders the :show template" do
          somechallenge = create(:challenge)  #uses factorygirl
          somechallenge.join_new_member(current_user)

          get :show, challenge_id: somechallenge.id

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
          expect(response).to redirect_to challenge
        end
        
      end

    end
  end

  describe 'Owner challenge access' do
    before{sign_in :user, owner}
    describe 'GET#index' do
      it "collects memberships into @memberships" do
        somechallenge = create(:challenge, owner_id: owner.id)
        somechallenge.join_new_member(create(:user))
        somechallenge.join_new_member(create(:user))

        get :index, challenge_id: somechallenge

        expect(assigns(:memberships)).to match_array(somechallenge.memberships)
      end

      it "renders the :index template" do
        somechallenge = create(:challenge, owner_id: owner.id)
        somechallenge.join_new_member(create(:user))
        somechallenge.join_new_member(create(:user))

        get :index, challenge_id: somechallenge

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
