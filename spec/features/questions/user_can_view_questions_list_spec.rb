require_relative '../acceptance_helper.rb'

feature 'User can view questions list', %q{
  In order to view questions list
  As user(any)
  I want to be able to view list of questions
}do

  given!(:questions) { create_list(:question, 2) }

  scenario 'User can get question\'s index' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.body
    end
  end

end
