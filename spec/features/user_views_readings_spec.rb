require 'spec_helper'

feature 'User manages readings' do
  background do
    @user = create(:user, :with_profile)
    @challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1-2")
    create(:membership, challenge: @challenge, user: @user)
    login(@user)
  end

  context "from the challenge page" do
    scenario "sees references to the reading pages" do
      pending
      visit challenge_path(@challenge)
      expect(page).to have_link "Matthew 1"
    end
    scenario "clicking reading link takes him to the reading page" do
      pending
      visit challenge_path(@challenge)
      click_link "Matthew 1"
      expect(current_path).to eq reading_path(@challenge.readings.first)
    end
  end
    


end
