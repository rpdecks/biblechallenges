require 'spec_helper'

feature "User manages membership reading" do

  let(:user) {create(:user)}

  before(:each) {
    login(user)
  }

  scenario "records a membership reading via challenge page 'Log' button" do
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1")
    chapter = challenge.chapters.first
    group = create(:group, user_id: user.id, challenge_id: challenge.id)
    create(:membership, user: user, challenge: challenge, group_id: group.id)

    visit member_challenge_path(challenge)
    expect{
      click_link_or_button "Log Matthew 1"
    }.to change(user.membership_readings, :count).by(1)
    mr = MembershipReading.last
    expect(mr.user_id).to eq user.id
    expect(mr.challenge_id).to eq challenge.id
    expect(mr.challenge_name).to eq challenge.name
    expect(mr.chapter_id).to eq chapter.id
    expect(mr.chapter_name).to eq chapter.book_and_chapter
    expect(mr.group_name).to eq group.name
    expect(mr.group_id).to eq group.id
  end
end
