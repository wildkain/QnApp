require_relative '../acceptance_helper.rb'

feature 'User can vote for answer', %q{
  In order to vote answer
  As user
  I want to be able to rate(or vote) answer

} do

  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create(:answer, question: question)}

  context  'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'Authenticated user vote UP to answer', js:true do
      within '.answers' do
        click_link 'Vote Up'
      end
      sleep(1)
      answer.reload
      expect(answer.votes_sum).to eq 1
    end

    scenario 'Authenticated user vote DOWN to answer', js:true do
      within '.answers' do
        click_link 'Vote Down'
      end
      sleep(1)
      answer.reload

      expect(answer.votes_sum).to eq -1
    end

    scenario 'Auth user try to vote for already voted answer', js: true do
      create(:vote, :up, user: user, votable: answer)
      visit question_path(question)

      within '.answers' do
        click_on 'Vote Up'
      end

      expect(page).to have_content "You have already voted for this"
    end

  end

  context 'Author try to vote for own answer' do
    given(:answer) { create(:answer, question: question, user: user)}

    before { sign_in(user); visit question_path(question) }
    scenario 'Author try to VOTE UP for answer' do
      within '.answers' do
        click_on 'Vote Up'
      end
      expect(page).to have_content "Author can't vote"
    end

    scenario 'Author try to VOTE DOWN for answer' do
      within '.answers' do
        click_on 'Vote Up'
      end

      expect(page).to have_content "Author can't vote"
    end

  end

  scenario 'Not-auth user try to vote answer', js: true do
    visit question_path(question)
    within '.answers' do
      click_link 'Vote Up'
    end

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end