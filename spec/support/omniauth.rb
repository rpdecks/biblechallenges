OmniAuth.config.test_mode = true

def mock_auth_hash
  omniauth_facebook = { 'provider' => 'facebook',
                    'uid' => '12345',
                    'info' => {
                      'name' => 'Barry',
                      'email' => 'barry.allen@flash.com',
                    }
  }

  omniauth_google = { 'provider' => 'google',
                    'uid' => '12345',
                    'info' => {
                      'name' => 'Peter',
                      'email' => 'peter.parker@spider.man',
                    }
  }

  OmniAuth.config.add_mock(:facebook, omniauth_facebook)
  OmniAuth.config.add_mock(:google, omniauth_google)
end
