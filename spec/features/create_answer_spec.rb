require 'rails_helper'

feature 'Any registered user can create question\s answer from question show', %q{
  In order to create question answer
  As logged_in user
  I want to be able to create question\'s answer on question page

} do
  given(:user) { create(:user) }
  given(:question) {create(:question)}
  scenario 'Registered user try to answer the question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: "Testanswer"
    click_button 'Answer the question'

    expect(page).to have_content 'Testanswer'
  end


  scenario 'Registered user try to create answer with empty body' do
    sign_in(user)
    visit question_path(question)
    click_button 'Answer the question'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non registered user try to create answer to question' do
    visit question_path(question)
    click_button 'Answer the question'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end




end