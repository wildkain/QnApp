require_relative '../acceptance_helper'


feature 'Delete attached file from answer', %q{
  In order to delete file from answer
  As answer's author
  I want to be able to delete attached file
}do
  given(:user) { create :user }
  given(:question) { create :question }
  given!(:answer) { create(:answer, question: question, user: user ) }
  given!(:attachment) { create(:attachment, attachmentable: answer) }


  scenario 'Answer author try to delete file', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_link 'Delete File'

      expect(page).to have_no_link 'test_file.txt'
    end
  end

    scenario 'Non-author answer try to delete attachment', js: true  do
      visit question_path(question)

      expect(page).to_not have_link 'Delete File'
    end
end
