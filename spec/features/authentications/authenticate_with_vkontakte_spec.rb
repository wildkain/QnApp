require_relative '../acceptance_helper.rb'

feature 'User can sign in with social media accounts', %q{
  In order to sign in with vkontakte account
  As new user
  I want to ba able to sign in with my vkontakte
} do
  given(:user) { create :user }

  scenario 'Try to sign in and signup with vkontakte(with email)' do
    visit new_user_session_path
    mock_auth_hash_vkontakte
    click_on 'Sign in with Vkontakte'
    sleep 2
    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    expect(page).to have_content 'vkontakte@test.com'
  end

  scenario 'Try to sign in and signup with invalid creds' do
    visit new_user_session_path
    mock_auth_hash_vkontakte_invalid
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials"'
  end

  scenario 'Sign in with vkontakte without email' do
    visit new_user_session_path
    mock_auth_hash_vkontakte_no_email
    click_on 'Sign in with Vkontakte'
    fill_in 'Email', with: 'emailforvkontakte@mail.com'
    click_on 'Submit'

    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    expect(page).to have_content 'emailforvkontakte@mail.com'
  end

end
