require_relative '../acceptance_helper.rb'

feature 'Search through resources' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) {create(:answer)}
  given(:comment){create(:comment, commentable: answer, user: user)}

  %w(Questions Answers Comment).each do |resource|
    scenario "#{resource} search", js: true, sphinx: true do
      visit root_path
      click_button 'Search'
      save_and_open_page
      expect(page).to have_content resource.body
      end
  end

  scenario "User search" do
    visit root_path
    fill_in "query", with: user.email
    click_button 'Search'

    save_and_open_page
    expect(page).to have_content user.email
  end
end