require_relative '../acceptance_helper.rb'

feature 'Add files to answer', %q{
  In oreder to add graphical description
  As answer's author
  I wan to be able to attach files to answer
}do

  given(:user) { create :user}
  given(:question) { create :question  }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User add files to answer on create', js: true do

    fill_in 'Your answer', with: 'Test BODY Answer'
    attach_file 'File', "#{Rails.root}/spec/test_file.txt"
    click_on 'Answer the question'
    sleep(2)
    save_and_open_page
    within '.answers' do
      expect(page).to have_link 'test_file.txt', href: '/uploads/attachment/file/1/test_file.txt'
    end
  end

  scenario 'User add  more then one files to answer on create', js: true  do

    fill_in 'Your answer', with: 'Test AnwerBody'
    attach_file 'File', "#{Rails.root}/spec/test_file.txt"
    click_link 'Add file'

    within page.all('.attached-fields')[1] do
      attach_file 'File', "#{Rails.root}/spec/test_file2.txt"
    end

    click_on 'Answer the question'
    sleep(2)

    expect(page).to have_link 'test_file.txt', href: '/uploads/attachment/file/1/test_file.txt'
    expect(page).to have_link 'test_file2.txt', href: '/uploads/attachment/file/2/test_file2.txt'
  end


end
