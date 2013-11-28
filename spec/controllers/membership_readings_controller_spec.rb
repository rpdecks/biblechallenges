require 'spec_helper'

describe MembershipReadingsController do
  
  let(:challenge){create(:challenge, chapterstoread:'mi 1-4')}
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}
  let(:membership_reading){membership.membership_readings.first}
  let(:hash){HashidsGenerator.instance.encrypt(membership_reading.id)}

  before do
    @request.host = "#{challenge.subdomain}.test.com"
  end

  describe "Routing" do
    let(:subdomainurl) { "http://#{challenge.subdomain}.test.com" }
    it {expect({get: "#{subdomainurl}/reading/confirm/#{hash}"}).to route_to(controller: 'membership_readings', action: 'confirm', hash: hash) }
    it {expect({put: "#{subdomainurl}/reading/log/#{hash}"}).to route_to(controller: 'membership_readings', action: 'log', hash: hash) }    
  end


  describe 'GET#confirm' do
    it "renders the :new template" do
      get :confirm, hash: hash
      expect(response).to render_template(:confirm)
    end    
    context 'with a valid hash' do

    end
  end

  describe 'PUT#log' do

    context 'with a valid hash' do

      it "finds membership_reading" do
        put :log, hash: hash
        expect(assigns(:membership_reading)).to eql(membership_reading)
      end

      it "changes membership_reading state to 'read'" do
        put :log, hash: hash
        expect(membership_reading.reload.state).to eql('read')
      end

    end

  end

end
