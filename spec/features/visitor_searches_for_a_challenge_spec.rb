require 'spec_helper'

feature 'Visitor searches for a challenge' do

  scenario 'Visitor searches for an existing challenge' do
    create(:challenge, name: 'Guy')
    create(:challenge, name: 'Phil')
    visit challenges_path
    fill_in "query", with: "Guy"
    click_button "Search"
    expect(page).to have_content 'Guy'
    expect(page).not_to have_content 'Phil'
  end
end

