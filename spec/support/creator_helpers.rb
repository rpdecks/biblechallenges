module CreatorHelpers
  def create_challenge(options = {})
    visit '/creator/challenges/new'
    #visit new_creator_challenge_path
    fill_in 'challenge_name', with: options[:name]
    fill_in 'challenge_subdomain', with: options[:subdomain]
    fill_in 'challenge_begindate', with: options[:begindate]
    fill_in 'challenge_enddate', with: options[:enddate]
    fill_in 'challenge_chapterstoread', with: options[:chapterstoread]
    click_button 'Create Challenge'
  end
end



RSpec.configure do |config|
  config.include CreatorHelpers
end
