module OmniauthMacros
  def mock_auth_hash_twitter
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '1234567',
      'info' => {
          'nickname' => 'wildkain',
          'email' => 'twitter@test.com'
      }
      })
  end

  def mock_auth_hash_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
        'provider' => 'vkontakte',
        'uid' => '123545',
        'info' => {
            'name' => 'wildkain',
            'email' => 'vkontakte@test.com'
        },
        'credentials' => {
            'token' => 'mock_token',
            'secret' => 'mock_secret'
        }
    })
  end

  def mock_auth_hash_twitter_invalid
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
  end

  def mock_auth_hash_vkontakte_invalid
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
  end


  def mock_auth_hash_twitter_no_email
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '1234567',
      'info' => {
          'nickname' => 'wildkain'
          }
       })
  end

  def mock_auth_hash_vkontakte_no_email
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
        'provider' => 'vkontakte',
        'uid' => '1234567',
        'info' => { 'nickname' => 'wildkain' }
        })
  end

end