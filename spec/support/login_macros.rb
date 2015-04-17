module LoginMacros

  def sign_up_and_in
    visit '/users/sign_up'
    fill_in 'Email', with: 'fakedude@fakedude.com'
    fill_in 'Password', with: 'woot111'
    fill_in 'Password confirmation', with: 'woot111'
    click_button 'Sign up'
  end

end