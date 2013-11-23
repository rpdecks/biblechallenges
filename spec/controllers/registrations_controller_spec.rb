require 'spec_helper'

describe RegistrationsController do

  before{@request.env["devise.mapping"] = Devise.mappings[:user]}

  describe 'PUT#update' do

    let(:current_user) { create(:user) }  

    before do
      sign_in :user, current_user
    end

    it 'locates the user' do
      put :update, user: {first_name:'newone',last_name:'newone',username:'newone'}
      expect(assigns(:user)).to eq(current_user)      
    end

    it 'updates basic information without requiring password' do
      put :update, user: {first_name:'newone',last_name:'newone',username:'newone'}
      # puts current_user.inspect
      # puts response.inspect
      current_user.reload
      expect(current_user.first_name).to eq('newone')
      expect(current_user.last_name).to eq('newone')
      expect(current_user.username).to eq('newone')
    end

    # it 'updates basic information without requiring password' do
      
    # end

  end

end
