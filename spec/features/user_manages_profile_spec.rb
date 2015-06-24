require 'spec_helper'

feature 'User manages profile' do
  let(:user) {create(:user)}

  scenario 'User views own profile successfully' do
    login(user)
    visit edit_user_registration_path
    expect(find_field('profile[first_name]').value).to eq user.first_name
  end

  scenario 'User edits profile succesfully'
end
