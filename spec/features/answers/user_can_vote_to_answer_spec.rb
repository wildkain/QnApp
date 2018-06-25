require_relative '../acceptance_helper.rb'

feature 'User can vote for answer', %q{
  In order to vote answer
  As user
  I want to be able to rate(or vote) answer

} do

  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create(:answer, question: question)}


  scenario 'Authenticated user vote UP to answer', js:true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_link 'Vote Up'
    end
    sleep(1)
    answer.reload

    expect(answer.sum_all).to eq 1
  end

  scenario 'Authenticated user vote DOWN to answer', js:true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_link 'Vote Down'
    end
    sleep(1)
    answer.reload

    expect(answer.sum_all).to eq -1
  end

  scenario 'Not-auth user try to vote answer' do
    visit question_path(question)
    within '.answers' do
      click_link 'Vote Up'
    end

    expect(page).to_have content "Only registered users can Vote!"
  end


  scenario 'Auth user try to vote for already voted answer' do
    sign_in(user)
    create(:vote, :up, user: user, votable: answer)

    visit question_path(question)

    within '.answers' do
      click_on 'Vote Up'

      expect(page).to have_content "You have already voted for this"
    end

  end


end