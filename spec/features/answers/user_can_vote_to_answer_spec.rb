require_relative '../acceptance_helper.rb'

feature 'User can vote for answer', %q{
  In order to vote answer
  As user
  I want to be able to rate(or vote) answer

} do

  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create(:answer, question: question)}


  scenario 'Authenticated user vote to answer', js:true do
    sign_in(user)
    visit question_path(question)
    save_and_open_page
    within '.answers' do
      click_link 'Vote UP'
    end


    expect(answer.rating).to change(answer, :rating).by(1)


  end

  scenario 'Not-auth user try to vote answer'

end