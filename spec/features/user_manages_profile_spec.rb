require 'spec_helper'

feature 'User manages user profile' do
  let(:user) {create(:user)}

  scenario 'User views own profile successfully' do
    skip "until we decide what to do with profile page"
    login(user)
    visit edit_user_registration_path
    save_and_open_page
    expect(find_field('user[name]').value).to eq user.name
  end

  scenario 'User edits profile succesfully'
end
