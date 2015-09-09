require 'spec_helper'

describe "member/challenges/show.html.haml" do
  before(:each) do
    #@user = user
    #view.stub(:current_user).and_return(@user)
    #assign(:note, build(:note, order_id: nil, content: nil, entered_by: nil))
  end

  it "displays today's reading date correctly" do
    challenge = assign(:challenge,
                       create(:challenge_with_readings, chapters_to_read: "Matthew 1"))
    user = create(:user)
    allow(challenge).to receive(:owner).and_return(user)
    #login(user)
    render
    expect(rendered).to have_content(Time.now.in_time_zone(user.time_zone).to_date)
  end
end

