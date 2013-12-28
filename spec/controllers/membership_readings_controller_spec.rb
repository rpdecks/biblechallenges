require 'spec_helper'

describe MembershipReadingsController do

  let(:challenge){create(:challenge, chapters_to_read:'mi 1-4')}
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}
  let(:membership_reading){membership.membership_readings.first}
  let(:hash){membership_reading.hash_for_url}

  before do
    @request.host = "#{challenge.subdomain}.test.com"
  end

  describe "Routing" do
    let(:subdomainurl) { "http://#{challenge.subdomain}.test.com" }
    it {expect({get: "#{subdomainurl}/reading/confirm/#{hash}"}).to route_to(controller: 'membership_readings', action: 'confirm', hash: hash) }
    it {expect({put: "#{subdomainurl}/reading/log/#{hash}"}).to route_to(controller: 'membership_readings', action: 'log', hash: hash) }
    it {expect({get: "#{subdomainurl}/membership_readings/#{hash}/edit"}).to route_to(controller: 'membership_readings', action: 'edit', id: hash) }
  end


  describe 'User access' do

    before do
      sign_in :user, user
      request.env["HTTP_REFERER"] = "where_i_came_from"  #to test redirect back
    end

    describe 'PUT#update' do
      it "finds the membership_reading" do
        put :update, id: membership_reading, format: 'js'
        expect(assigns(:membership_reading)).to eql(membership_reading)
      end

      it "assigns comment" do
        put :update, id: membership_reading
        expect(assigns(:comment)).to be_true
      end

      it "assigns user" do
        put :update, id: membership_reading
        expect(assigns(:user)).to be_true
      end

      it "assigns reading" do
        put :update, id: membership_reading
        expect(assigns(:reading)).to be_true
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
    context 'with a valid hash' do
      it "renders the :edit template" do
        get :edit, id: hash
        expect(response).to render_template(:edit)
      end

      it "finds the membership_reading's user" do
        get :edit, id: hash
        expect(assigns(:user)).to eql(membership_reading.membership.user)
      end

      it "finds the membership_reading's reading" do
        get :edit, id: hash
        expect(assigns(:reading)).to eql(membership_reading.reading)
      end

      it "assigns a comment to be available in the form" do
        get :edit, id: hash
        expect(assigns(:comment)).to be_true
      end


    end
  end


  describe 'GET#confirm' do
    context 'with a valid hash' do

      it "renders the :new template" do
        get :confirm, hash: hash
        expect(response).to render_template(:confirm)
      end

      it "renders with email layout" do
        get :confirm, hash: hash
        should render_with_layout('from_email')
      end

      it "finds the membership_reading's user" do
        get :confirm, hash: hash
        expect(assigns(:user)).to eql(membership_reading.membership.user)
      end

      it "finds the membership_reading's reading" do
        get :confirm, hash: hash
        expect(assigns(:reading)).to eql(membership_reading.reading)
      end

    end

    context 'with an invalid hash' do
      let(:hash){'gB0NV05e'}

      it "renders the :new template" do
        get :confirm, hash: hash
        expect(response).to render_template(:confirm)
      end

      it "renders with email layout" do
        get :confirm, hash: hash
        should render_with_layout('from_email')
      end

      it 'sets a proper flash message' do
        get :confirm, hash: hash
        should set_the_flash[:error].to("This confirmation link doesn't exist")
      end
    end

  end

  describe 'PUT#log' do

    context 'with a valid hash' do
      it "finds membership_reading" do
        put :log, hash: hash, format:'js'
        expect(assigns(:membership_reading)).to eql(membership_reading)
      end

      it "changes membership_reading state to 'read'" do
        put :log, hash: hash, format:'js'
        expect(membership_reading.reload.state).to eql('read')
      end
    end

  end

end
