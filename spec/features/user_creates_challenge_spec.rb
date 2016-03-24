require 'spec_helper'

feature 'User manages challenges' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'User creates a challenge' do
    visit root_path
    click_link 'Create a challenge'

    Sidekiq::Testing.inline! do
      fill_in 'challenge[name]', with: "challenge 1"
      fill_in 'challenge[begindate]', with: Date.today
      fill_in 'challenge[chapters_to_read]', with: "Matthew 1-2"

      click_button "Create Challenge"

      expect(Challenge.all.size).to eq 1

      number_of_stats = ChallengeStatistic.descendants.size
      expect(ChallengeStatistic.count).to eq number_of_stats

      all_emails = ActionMailer::Base.deliveries
      expect(all_emails.size).to eq 2 #Today's reading and new membership email

      todays_reading = all_emails.last
      expect(todays_reading.subject).to include "challenge 1...BibleChallenges.com reading"
    end
  end

  scenario 'User creates a challenge and automatically joins the challenge' do
    visit root_path
    click_link 'Create a challenge'
    expect{
      fill_in 'challenge[name]', with: "challenge 1"
      fill_in 'challenge[begindate]', with: Date.today
      fill_in 'challenge[chapters_to_read]', with: "Matthew 1-2"
      click_button "Create Challenge"
    }.to change(Challenge, :count).by(1)
    expect(Membership.count).to be 1
    expect(Membership.first.user).to eq user
  end

  scenario 'User creates a challenge and sees confirmation page/message' do
    visit root_path
    click_link 'Create a challenge'

    fill_in 'challenge[name]', with: "challenge 1"
    fill_in 'challenge[begindate]', with: Date.today
    fill_in 'challenge[enddate]', with: (Date.today + 7.days)
    fill_in 'challenge[chapters_to_read]', with: "Matthew 1-2"
    click_button "Create Challenge"
    expect(page).to have_content("Successfully created Challenge")
  end

  scenario 'User creates a challenge with leading space in name' do
    visit root_path
    click_link 'Create a challenge'

    fill_in 'challenge[name]', with: "  leading-and-trailing-spaces  "
    fill_in 'challenge[begindate]', with: Date.today
    fill_in 'challenge[chapters_to_read]', with: "Matthew 1-2"

    click_button "Create Challenge"

    expect(page).to have_content("Successfully created Challenge")
  end

  scenario 'User creates a future challenge' do
    visit root_path
    click_link 'Create a challenge'

    fill_in 'challenge[name]', with: "awesome"
    fill_in 'challenge[begindate]', with: Date.tomorrow
    fill_in 'challenge[chapters_to_read]', with: "Matthew 1-2"

    click_button "Create Challenge"

    expect(page).to have_content("Successfully created Challenge")
  end
end
