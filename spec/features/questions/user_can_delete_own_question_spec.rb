require 'rails_helper'

feature 'User can delete own question', %q{
  In order to delete question
  As user
  I want to be able to delete my question

} do

  given(:user) { create :user }
  given(:not_author) { create :user }
  given(:question) { create(:question, user: user) }

  scenario 'Author can delete  own question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete Question'

    expect(page).to have_no_content(question.title)
  end

  scenario 'Not-author try to delete question' do
    sign_in(not_author)
    visit question_path(question)

    expect(page).to_not have_content 'Delete Question'
  end

  scenario 'Non-registered user try to delete question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete Question'
  end

end
