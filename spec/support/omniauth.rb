OmniAuth.config.test_mode = true
omniauth_hash = { 'provider' => 'facebook',
                  'uid' => '12345',
                  'info' => {
                    'name' => 'Barry', 
                    'email' => 'barry.allen@flash.com',
                  }
}

OmniAuth.config.add_mock(:facebook, omniauth_hash)
