require 'spec_helper'

feature 'User manages profile' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'User views own profile successfully' do
    visit edit_profile_path
    expect(find_field('profile[first_name]').value).to eq user.first_name
  end

end
