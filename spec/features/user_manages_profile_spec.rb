require 'spec_helper'

feature 'User manages user profile' do
  scenario 'User edits own profile successfully' do
    user = create(:user)
    login(user)
    new_user_params = build(:user)
    visit edit_user_path

    fill_in 'user[name]', with: new_user_params.name
    select '(GMT-09:00) Alaska', from: 'Time Zone'
    select '13:00', from: 'Preferred Reading Hour'
    click_button 'Update User'

    user = User.first
    expect(user.name).to eq new_user_params.name
    expect(user.time_zone).to eq "Alaska"
    expect(user.preferred_reading_hour).to eql 13
  end

  scenario 'User removes avatar file' do
    user = create(:user_with_avatar)
    login(user)
    visit edit_user_path
    click_link 'Remove Avatar'
    expect(page).to have_content 'User avatar has been removed'
    user.reload
    expect(user.avatar_file_name).to be_nil
  end
end
