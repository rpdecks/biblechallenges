require 'spec_helper'

feature 'User manages readings' do
  background do
    @user = create(:user)
    @challenge = create(:challenge, name: "Testy Challenge", chapters_to_read: "Matthew 1-9", owner: @user, begindate: Date.today, enddate: Date.tomorrow)
    create(:membership, challenge: @challenge, user: @user)
    @challenge.generate_readings
    login(@user)
  end

  scenario "sees references to the reading pages" do
    visit challenge_path(@challenge)
    expect(page).to have_link "Matthew 1"
  end

  scenario "clicking reading link takes him to the reading page" do
    visit challenge_path(@challenge)
    click_link "Matthew 1"
    expect(current_path).to eq reading_path(@challenge.readings.first)
  end

  scenario "from chapters reading page sees and links to 'next chapter'" do
    visit challenge_path(@challenge)
    click_link "Matthew 2"
    expect(page).to have_link "Matthew 3"
    click_link "Matthew 3"
    expect(current_path).to eq reading_path(@challenge.readings.third)
  end
end
