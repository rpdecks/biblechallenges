OmniAuth.config.test_mode = true

def mock_auth_hash(provider, email)
  if provider == "facebook"
    omniauth_user_params = build(:existing_facebook_user)
  elsif provider == "google_oauth2"
    omniauth_user_params = build(:existing_google_user)
  end
  omniauth = { 'provider' => omniauth_user_params.provider,
               'uid' => omniauth_user_params.uid,
               'info' => {
                 'name' => omniauth_user_params.name,
                 'email' => email,
               }
  }
  OmniAuth.config.add_mock(provider.to_sym, omniauth)
end

def mock_auth_user(provider, fb_user)
  omniauth = { 'provider' => fb_user.provider,
               'uid' => fb_user.uid,
               'info' => {
                 'name' => fb_user.name,
                 'email' => fb_user.email,
               }
  }
  OmniAuth.config.add_mock(provider.to_sym, omniauth)
end
