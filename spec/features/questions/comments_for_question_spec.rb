require_relative '../acceptance_helper.rb'


feature 'Add comments to question', %q{
  In order to comment and explain
  As logged_in user
  I want to be able to comment questions
} do
  given(:user) { create :user }
  given(:question) { create(:question, user: user)}

  scenario "Logged in user add a comment to question", js: true do
    sign_in(user)
    visit question_path(question)
    within '.comments_form' do
      fill_in "Your comment", with: "Test comment"
      click_on 'Add a comment'
    end
    sleep 3

    expect(page).to have_content 'Test comment'
  end

  context 'multiple sessions' do
    scenario 'comment appears to another user page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your comment', with: 'My comment'
        click_on 'Add a comment'
        within '.comments' do
          expect(page).to have_content 'My comment'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'My comment'
        end
      end
    end
  end


  scenario "Not-logged in user try to comment question" do

  end
end