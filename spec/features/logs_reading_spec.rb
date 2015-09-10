require 'spec_helper'

feature "User logs reading" do

  let(:user) {create(:user)}

  scenario "via challenge page 'Log' button" do
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1")
    ChallengeCompletion.new(challenge)
    create(:membership, user: user, challenge: challenge)

    login(user)
    visit member_challenge_path(challenge)

    expect{
      click_link_or_button "Log Matthew 1"
    }.to change(user.membership_readings, :count).by(1)
  end

  scenario "via challenge page readings table checkbox"
end


