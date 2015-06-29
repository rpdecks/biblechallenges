require 'spec_helper'

feature 'User manages user profile' do
  let(:user) {create(:user)}

  scenario 'User edits own profile successfully' do
    login user
    new_user_params = build(:user)
    visit edit_user_path user

    fill_in 'user[name]', with: new_user_params.name
    click_button 'Update User'
    expect(user.name).to eq new_user_params.name
  end

  scenario 'User edits profile succesfully'
end
