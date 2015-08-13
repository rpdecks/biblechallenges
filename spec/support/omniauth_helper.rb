OmniAuth.config.test_mode = true

def mock_auth_hash(provider, email)
  fb_user_params = build(:facebook_user)
  omniauth = { 'provider' => fb_user_params.provider,
               'uid' => fb_user_params.uid,
               'info' => {
                 'name' => fb_user_params.name,
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
