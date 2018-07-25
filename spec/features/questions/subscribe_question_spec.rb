require_relative '../acceptance_helper.rb'

feature "User can Subscribe! for question", %q{
  In order not to miss new answers for question
  As Author or Subscribed user
  I want to be able to subscribe to  updates
}do

  given(:user) { create :user }
  given(:question) {create :question }
  given(:authored_question) { create(:question, user: user)}


  scenario "User subcribe to question", js: true do
    sign_in(user)
    visit question_path(question)
    click_link "Subscribe me!"

    expect(page).to have_content "Unsubscribe"
  end
  context 'User already subscribed for question' do
    given!(:subscription) { create(:subscription, user: user, question: question)}
    scenario "User unsubscribe to question", js:true do
      sign_in(user)
      visit question_path(question)
      save_and_open_page
      click_link "Unsubscribe me!"

      expect(page).to have_content "Subscribe me!"
    end
  end

end