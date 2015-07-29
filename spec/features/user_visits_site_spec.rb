require 'spec_helper'

feature 'User visits challenges' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'User only sees the current challenges, not the outdated ones' do
    Timecop.travel(-2.day)
      ch1_start_date = Date.today
      challenge = create(:challenge_with_readings, chapters_to_read: "Matt 1-2", begindate: ch1_start_date)
    Timecop.return
    ch2_start_date = Date.today
      challenge2 = create(:challenge_with_readings, chapters_to_read: "Matt 1-2", begindate: ch2_start_date)
    visit root_path
    expect(page).to_not have_content(challenge.name)
    expect(page).to have_content(challenge2.name)
  end
end
