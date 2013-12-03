require 'spec_helper'

describe RegistrationsController do

  before{@request.env["devise.mapping"] = Devise.mappings[:user]}

  describe 'PUT#update' do

    let(:current_user) { create(:user, password:'loquillo' , password_confirmation:'loquillo') }  

    before do
      sign_in :user, current_user
    end

    context 'when password is not required' do

      it 'locates the user' do
        put :update, user: {first_name:'newone',last_name:'newone',username:'newone'}
        expect(assigns(:user)).to eq(current_user)      
      end

      it 'updates basic information' do
        put :update, user: {first_name:'newone',last_name:'newone',username:'newone'}
        current_user.reload
        expect(current_user.first_name).to eq('newone')
        expect(current_user.last_name).to eq('newone')
        expect(current_user.username).to eq('newone')
      end
      
    end


    context 'when password is required' do

      it 'locates the user' do
        put :update, user: {password:'newone' , password_confirmation:'newone', current_password:'loquillo'}
        expect(assigns(:user)).to eq(current_user)      
      end

      it 'updates password if password_confirmation is correct' do
        put :update, user: {password:'newone' , password_confirmation:'newone', current_password:'loquillo'}
        current_user.reload
        expect(current_user.valid_password?('newone')).to be_true
      end
      
    end

  end

end
