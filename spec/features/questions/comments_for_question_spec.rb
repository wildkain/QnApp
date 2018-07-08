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

    within ".question-block" do
      click_on "Add Comment"
      fill_in "Your comment", with: "Test comment"
      click_on 'Add a comment'
    end
    sleep 3

    expect(page).to have_content 'Test comment'
  end

  context 'User can do some actions(update, delete) with comment' do
    given!(:comment){ create(:comment, user: user, commentable: question)}
    before { sign_in(user); visit question_path(question) }
    scenario 'Author of comment can delete comment', js: true do

      within ".comment#comment_#{comment.id}_for_question_#{question.id}" do
        click_on 'Delete Comment'
      end
      expect(page).to_not have_content "Just Comment"

    end

    scenario 'User can update own comment', js: true do
      within ".comment#comment_#{comment.id}_for_question_#{question.id}" do
        click_on 'Edit comment'
        fill_in 'Comment', with: 'Updated Comment'
        click_on 'Update Comment'
        sleep 2

        expect(page).to_not have_content 'Just Comment'
      end
    end
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
        within ".question-block" do
          click_on 'Add Comment'
          fill_in 'Your comment', with: 'My comment'
          click_on 'Add a comment'
        end
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