require_relative '../acceptance_helper.rb'

feature 'Add files to question', %q{
  In oreder to add graphical description
  As question's author
  I wan to be able to attach files to auestion
}do

  given(:user) { create :user}

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User add files to question on create' do
    fill_in 'Title', with: 'Test TITLE question'
    fill_in 'Body', with: 'Test BODY question'
    attach_file 'File', "#{Rails.root}/spec/test_file.txt"
    click_on 'Create'

    expect(page).to have_link 'test_file.txt', href: '/uploads/attachment/file/1/test_file.txt'

  end



end
