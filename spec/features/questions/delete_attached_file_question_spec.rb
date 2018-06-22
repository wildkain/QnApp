require_relative '../acceptance_helper.rb'


feature 'Delete attached file from question', %q{
  In order to delete file from question
  As answer's author
  I want to be able to delete attached file
}do
  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given!(:attachment) { create(:attachment, attachmentable: question) }


  scenario 'Question author try to delete file', js: true do
    sign_in(user)
    visit question_path(question)

    within '.attachments' do
      click_link 'Delete File'

      expect(page).to have_no_link 'test_file.txt'
    end
  end

  scenario 'Non-author cant see delete link', js: true  do
    visit question_path(question)
    within '.attachments' do
      expect(page).to_not have_link 'Delete File'
    end
  end
end
