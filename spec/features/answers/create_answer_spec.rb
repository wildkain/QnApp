require_relative '../acceptance_helper.rb'

feature 'Any registered user can create question\s answer from question show', %q{
  In order to create question answer
  As logged_in user
  I want to be able to create question\'s answer on question page

} do
  given(:user) { create(:user) }
  given(:question) {create(:question)}

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    click_on 'Answer the question'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Registered user try to create answer with empty body', js: true do
    sign_in(user)
    visit question_path(question)
    click_button 'Answer the question'

    expect(page).to have_content 'Body can\'t be blank'
  end

  context 'multiple sessions' do
    scenario 'answer appears to another user page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'My answer'
        click_on 'Answer the question'
        within '.answers' do
          expect(page).to have_content 'My answer'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'My answer'
        end
      end
    end
  end

  scenario 'Non registered user try to create answer to question' do
    visit question_path(question)

    expect(page).to_not have_content 'Answer the question'
  end
end
