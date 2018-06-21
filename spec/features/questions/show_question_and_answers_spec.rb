require_relative '../acceptance_helper.rb'

feature 'User can view the question and answers', %q{
  In order to view question and questions answer
  As user
  I want to be able to view question, and it's answers
} do
  given(:user) {create :user}
  given(:question) {create :question}
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Registered user try to view question and answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Non-Registered user try to view question and answers' do
    visit question_path(question)
    expect(page).to have_content question.title
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

end
