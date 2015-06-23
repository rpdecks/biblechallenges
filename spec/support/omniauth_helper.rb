OmniAuth.config.test_mode = true

def mock_auth_hash(provider, email)
  omniauth = { 'provider' => provider,
               'uid' => '12345',
               'info' => {
                 'name' => email.split("@")[0],
                 'email' => email,
               }
  }

  OmniAuth.config.add_mock(provider.to_sym, omniauth)
end
