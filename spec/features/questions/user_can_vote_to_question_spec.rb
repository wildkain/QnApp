require_relative '../acceptance_helper.rb'

feature 'User can vote for question', %q{
  In order to vote question
  As user
  I want to be able to rate(or vote) question

} do

  given(:user) { create :user }
  given(:author) {create :user}
  given!(:question) { create(:question, user: author) }


  context  'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'Authenticated user vote UP to question', js:true do
      within '.question-block' do
        click_link 'Vote Up'
      end
      sleep(1)
      question.reload
      expect(question.sum_all).to eq 1
    end

    scenario 'Authenticated user vote DOWN to question', js:true do
      within '.question-block' do
        click_link 'Vote Down'
      end
      sleep(1)
      question.reload

      expect(question.sum_all).to eq -1
    end

    scenario 'Auth user try to vote for already voted question', js: true do
      create(:vote, :up, user: user, votable: question)
      visit question_path(question)

      within '.question-block' do
        click_on 'Vote Up'
      end

      expect(page).to have_content "You have already voted for this"
    end
  end

  context 'Author try to vote for own question' do


    before { sign_in(author); visit question_path(question) }
    scenario 'Author try to VOTE UP for question' do
      within '.question-block' do
        click_on 'Vote Up'
      end
      expect(page).to have_content "Author can't vote"
    end

    scenario 'Author try to VOTE DOWN for question' do
      within '.question-block' do
        click_on 'Vote Up'
      end

      expect(page).to have_content "Author can't vote"
    end
  end

  scenario 'Not-auth user try to vote question', js: true do
    visit question_path(question)
    within '.question-block' do
      click_link 'Vote Up'
    end

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end