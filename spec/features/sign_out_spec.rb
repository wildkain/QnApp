require 'rails_helper'


feature 'Sign out user', %q{
  In order to sign out
  As authentic user
  I want to be able to sign out from system

}do
  given(:user) { create(:user) }
  scenario 'Authenticated user try to sign out' do
    sign_in(user)

    expect(page).to have_content 'Logout'
  end

  scenario 'User can logout' do
    sign_in(user)
    click_on 'Logout'
    save_and_open_page
    expect(page).to have_content 'Login'

  end
end