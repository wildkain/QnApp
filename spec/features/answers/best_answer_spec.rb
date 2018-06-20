require_relative '../acceptance_helper.rb'

feature 'Question author can select best answer', %q{
  In order to select best answer
  As author of question
  I want to be able to select best answer
} do
    given(:author) { create :user }
    given(:not_author) { create :user }
    given!(:author_question) { create(:question, user: author)}
    given!(:answers) { create_list(:answer, 3, question: author_question, user: author) }

  scenario 'Author of question select best answer', js: true  do
    sign_in(author)
    visit question_path(author_question)
    answer_to_best = author_question.answers.last

    within("#answer-#{answer_to_best.id}") do
      click_link('Best Answer')
    end

    expect(page).to have_css '.best-answer'
  end

  scenario 'Non-author of question try to select best answer', js: true  do
    sign_in(not_author)
    visit question_path(author_question)

    within '.answers' do
      expect(page).to_not have_link "Best Answer"
    end
  end

    scenario 'Not-authenticated user try to select best answer', js: true  do

      visit question_path(author_question)

      within '.answers' do
        expect(page).to_not have_link "Best Answer"
      end
    end
end