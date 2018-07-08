require_relative '../acceptance_helper.rb'

feature 'Create question', %q{
  In order to get answer from comunity
  As authenticated user
  I want to be able to create questions
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test TITLE question'
    fill_in 'Body', with: 'Test BODY question'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test TITLE question'
    expect(page).to have_content 'Test BODY question'
  end

  scenario 'Authenticated user try to create question with invalid data' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test TITLE question'
    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'multiple sessions' do
    scenario 'question appears to another user page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test TITLE question'
        fill_in 'Body', with: 'Test BODY question'
        click_on 'Create'
        sleep 1

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test TITLE question'
        end
      end
    end
  end

end
