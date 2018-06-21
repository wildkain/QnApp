require_relative '../acceptance_helper.rb'

feature 'Add files to answer', %q{
  In oreder to add graphical description
  As answer's author
  I wan to be able to attach files to answer
}do

  given(:user) { create :user}
  given(:question) { create :question }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User add files to answer on create', js: true do

    fill_in 'Your answer', with: 'Test BODY Answer'
    attach_file 'File', "#{Rails.root}/spec/test_file.txt"
    click_on 'Answer the question'

    within '.answers' do
      expect(page).to have_link 'test_file.txt', href: '/uploads/attachment/file/1/test_file.txt'
    end
  end



end
