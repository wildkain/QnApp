require_relative '../acceptance_helper.rb'

feature 'User can sign in with social media accounts', %q{
  In order to sign in with twitter account
  As new user
  I want to ba able to sign in with my twitter
} do
    given(:user) { create :user }

    context "Sign in user" do
      before do
        clear_emails
        visit new_user_session_path
      end

    scenario 'Try to sign in and signup with twitter(with email)' do
      mock_auth_hash_twitter
      click_on 'Sign in with Twitter'
      sleep 2

      open_email('twitter@test.com')
      current_email.click_link 'Confirm my account'

      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_content 'twitter@test.com'
    end

    scenario 'Try to sign in and signup with invalid creds' do
      mock_auth_hash_twitter_invalid
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
    end

    scenario 'Sign in with twitter without email' do
      mock_auth_hash_twitter_no_email
      click_on 'Sign in with Twitter'
      fill_in 'Email', with: 'emailfortwitter@mail.com'
      click_on 'Submit'

      open_email('emailfortwitter@mail.com')
      current_email.click_link 'Confirm my account'

      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_content 'emailfortwitter@mail.com'
    end

  end
end