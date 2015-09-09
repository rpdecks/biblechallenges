require 'spec_helper'

describe "member/challenges/show.html.haml" do
  it "displays today's reading date correctly" do
    skip "attempt to test view"
    challenge = assign(:challenge,
                       create(:challenge_with_readings, chapters_to_read: "Matthew 1"))
    user = create(:user)
    allow(view).to receive_messages(:current_user => user)
    allow(challenge).to receive(:owner).and_return(user)
    allow(challenge).to receive(:book_chapters).and_return([[40, 1]])
    render
    expect(rendered).to have_content(Time.now.in_time_zone(user.time_zone).to_date)
  end
end

