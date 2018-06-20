require_relative '../acceptance_helper.rb'

feature 'User can update question', %q{
  In odrer to fix mistakes
  As user
  I want to have possible to edit question
}do

  given(:author) {create(:user)}
  given!(:not_author) { create(:user)}
  given(:question) {create(:question, user: author)}


  scenario 'Author try to edit question', js: true  do
    sign_in(author)
    visit question_path(question)
    click_on 'Edit Question'
    fill_in "Title", with: 'Authored title edited'
    fill_in "Body", with: 'Authored Body edited'
    click_on "Save"

    expect(page).to have_content "Edit Question"
    expect(page).to have_content 'Authored title edited'
  end

  scenario 'Another user(not author) try to edit question' do
    sign_in(not_author)
    visit question_path(question)

    expect(page).to_not have_content "Edit Question"
    end

  scenario 'Not-logged_in user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_content "Edit Question"
  end

end
