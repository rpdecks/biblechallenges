module CreationMacros
  def create_challenge(options = {})
    visit '/creator/challenges/new'
    #visit new_creator_challenge_path
    fill_in 'challenge_name', with: options[:name]
    fill_in 'challenge_subdomain', with: options[:subdomain]
    fill_in 'challenge_begindate_input', with: options[:begindate]
    fill_in 'challenge_enddate_input', with: options[:enddate]
    fill_in 'challenge_chapterstoread', with: options[:chapterstoread]
    click_button 'Create Challenge'
  end
end