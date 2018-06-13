require_relative '../acceptance_helper.rb'

feature 'Answer editing', %q{
  In order to fix mistakes
  As an author of answer
  I want to be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) {create(:question)}
  given!(:answer) { create(:answer, question: question)}

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


  describe  'Authencicated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end
  scenario 'Author try to find Edit link' do
    save_and_open_page
    within '.answers' do
      expect(page).to have_link 'Edit'
    end
  end

  scenario 'Author try to edit his answer',  js: true do
    click_on 'Edit'
    within '.answers' do
      fill_in 'Answer', with: 'edited answer'
      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
    end
  end
  scenario 'Authenticated user(but not autrhor) try to edit answer'
    given(:another_user) {create(:user)}
    given!(:question) { create(:question)}
    given!(:authored_answer) {create(:answer, question: question, user: user)}
    sign_in(another_user)
    visit question_path(question)
    click_on 'Edit'

    expect(page).to_not have_selector 'textarea'

  end
end