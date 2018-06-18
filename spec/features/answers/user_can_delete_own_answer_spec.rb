require_relative '../acceptance_helper.rb'

feature 'User can delete own answer', %q{
  In order to delete answer
  As user
  I want to be able to delete my answer

} do

  given(:user) { create :user }
  given(:question) { create(:question, user: user) }
  given(:not_author) { create :user }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author can delete  own answer' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete Answer'

    expect(page).to_not have_content(answer.body)
  end

  scenario 'Not-author try to delete answer' do
    sign_in(not_author)
    visit question_path(question)

    expect(page).to_not have_content 'Delete Answer'
  end

  scenario 'Non-registered user try to delete Answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete Answer'
  end

end