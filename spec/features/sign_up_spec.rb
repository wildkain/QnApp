require_relative 'acceptance_helper'

feature 'Any non-registered user can sign up', %q{
  In order to sign up
  As non-registered user
  I want to be able to sign up
}do
  scenario 'Non registered user try to sign up' do
    visit root_path
    expect(page).to have_content 'SignUp'
  end

  scenario 'Non-registered user redirected to sign_up page and try to signup' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user123@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Non-registered user try to sign up with invalid data(email)' do
    visit new_user_registration_path
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'

    expect(page).to have_content 'Email can\'t be blank'
  end
end
