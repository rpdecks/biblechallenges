module CreatorHelpers
  def create_challenge(options = {})
    visit '/creator/challenges/new'
    #visit new_creator_challenge_path
    fill_in 'Name', with: options[:name]
    fill_in 'Subdomain', with: options[:subdomain]
    fill_in 'Begindate', with: options[:begindate]
    fill_in 'Enddate', with: options[:enddate]
    click_button 'Create Challenge'
  end
end



Rspec.configure do |config|
  config.include CreatorHelpers
end
