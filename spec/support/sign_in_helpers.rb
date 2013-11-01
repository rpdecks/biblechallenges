module SignInHelpers

  def sign_up_as(email, password)
    visit '/users/sign_up'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', password
    click_button 'Sign up'
  end

end

Rspec.configure do |config|
  config.include SignInHelpers
end
