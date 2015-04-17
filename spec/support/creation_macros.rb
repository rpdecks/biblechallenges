module CreationMacros
  def create_challenge(options = {})
    visit '/creator/challenges/new'
    #visit new_creator_challenge_path
    fill_in 'challenge_name', with: options[:name]
    fill_in 'challenge_subdomain', with: options[:subdomain]
    fill_in 'challenge_begindate_input', with: options[:begindate]
    fill_in 'challenge_chapters_to_read', with: options[:chapters_to_read]
    click_button 'Create Challenge'
  end
end
