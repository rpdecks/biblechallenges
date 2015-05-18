require 'spec_helper'

feature 'Visitor views badges' do

  scenario 'Visitor views all badges' do
    visit badges_path
    expect(page).to have_content("One Chapter Read")
    expect(page).to have_content("Join Challenge Badge")
  end

  scenario 'Visitor views one badges details' do
    badge_class = OneChapterBadge

    visit badge_path(id: badge_class.to_s)

    # if we pass in that class name, the show page should
    # have the name and description of the badge
    expect(page).to have_content(badge_class.new.name)
    expect(page).to have_content(badge_class.new.description)
  end

  scenario 'Visitor clicks on a badge name to see its details' do
    badge_class = JoinChallengeBadge
    visit badges_path
    click_link badge_class.to_s

    # we should be on the show page by now
    expect(page).to have_content(badge_class.new.name)
    expect(page).to have_content(badge_class.new.description)
  end

  scenario "foo" do

    user2 = create(:user)
    user2.badges << JoinChallengeBadge.create(granted: false)
    user2.badges << OneChapterBadge.create(granted: false)

    user = create(:user)
    user.badges << JoinChallengeBadge.create(granted: true)
    user.badges << OneChapterBadge.create(granted: false)


    binding.pry



  end

end



