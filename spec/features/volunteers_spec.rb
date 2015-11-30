require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
feature 'volunteers' do
  before(:each) do
    DatabaseCleaner.clean
  end
  let!(:test_volunteer) { create(:volunteer) }
  scenario 'add a volunteer' do
    visit new_volunteer_path
    fill_in('volunteer_first_name', with: 'Jane')
    fill_in('volunteer_last_name', with: 'Doe')
    click_button('Submit')
    expect(page).to have_content 'Jane'
  end

  scenario 'view list of volunteers' do
    visit volunteers_path
    expect(page).to have_content 'Jane'
  end

  scenario 'edit volunteer' do
    visit edit_volunteer_path(test_volunteer.id)
    expect(page).to have_content 'Edit'
    fill_in('volunteer_first_name', with: 'Sara Jane')
    click_button('Submit')
    expect(page).to have_content 'Sara Jane'
  end
end
