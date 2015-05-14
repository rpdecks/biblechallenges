require 'spec_helper'

describe MembershipReadingsController, type: :controller do

  let(:challenge){create(:challenge, chapters_to_read:'mi 1-4')} 
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}
  let(:membership_reading){ create(:membership_reading, membership: membership)}


  describe 'User access' do

    before do
      sign_in :user, user
      request.env["HTTP_REFERER"] = "where_i_came_from"  #to test redirect back
    end

    describe 'PUT#update' do
      it "finds the membership_reading" do
        #membership_reading = create(:membership_reading, membership: membership)
        put :update, id: membership_reading, format: 'js'
        expect(assigns(:membership_reading)).to eql(membership_reading)
      end

      it "assigns comment" do
        put :update, id: membership_reading
        expect(assigns(:comment)).to be_truthy
      end

      it "assigns user" do
        put :update, id: membership_reading
        expect(assigns(:user)).to be_truthy
      end

      it "assigns reading" do
        put :update, id: membership_reading
        expect(assigns(:reading)).to be_truthy
      end
    end

  end


  describe 'Guest access' do
    describe 'PUT#update' do
      it "redirects to the log in page" do
        put :update, id: membership_reading
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET#edit' do
    context 'with a valid token' do
      it "renders the :edit template" do
        get :edit, id: membership_reading.id, user_email: user.email, user_token: user.authentication_token
        expect(response).to render_template(:edit)
      end

      it "finds the membership_reading's user" do
        get :edit, id: membership_reading.id, user_email: user.email, user_token: user.authentication_token
        expect(assigns(:user)).to eql(membership_reading.membership.user)
      end

      it "finds the membership_reading's reading" do
        get :edit, id: membership_reading.id, user_email: user.email, user_token: user.authentication_token
        expect(assigns(:reading)).to eql(membership_reading.reading)
      end

      it "assigns a comment to be available in the form" do
        get :edit, id: membership_reading.id, user_email: user.email, user_token: user.authentication_token
        expect(assigns(:comment)).to be_truthy
      end
    end

    context "with an invalid token" do
      it "set the flash with an error message" do
        pending
        get :edit, id: "blah"
        should set_the_flash
      end
    end

  end


  describe 'GET#confirm' do
    context 'with a valid token' do

      it "renders the :new template" do
        get :confirm, id: membership_reading.id
        expect(response).to render_template(:confirm)
      end

      it "renders with email layout" do
        get :confirm, id: membership_reading.id
        should render_with_layout('from_email')
      end

      it "finds the membership_reading's user" do
        get :confirm, id: membership_reading.id
        expect(assigns(:user)).to eql(membership_reading.membership.user)
      end

      it "finds the membership_reading's reading" do
        get :confirm, id: membership_reading.id
        expect(assigns(:reading)).to eql(membership_reading.reading)
      end

    end


  end

  describe 'PUT#log' do

    context 'with a valid token' do
      it "finds membership_reading" do
        put :log, id: membership_reading.id, format:'js'
        expect(assigns(:membership_reading)).to eql(membership_reading)
      end

      it "changes membership_reading state to 'read'" do
        put :log, id: membership_reading.id, format:'js'
        expect(membership_reading.reload.state).to eql('read')
      end
    end

  end

end
