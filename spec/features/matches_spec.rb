require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
feature "matches" do
  before(:each) do
    DatabaseCleaner.clean
  end
  let!(:test_client) { create(:client) }
  let!(:test_volunteer) { create(:volunteer) }
  scenario "add a match" do
    visit new_match_path
    select(test_client.id, :from => 'Client')
    select(test_volunteer.id, :from => 'Volunteer')
    click_button('Submit')
    expect(page).to have_content 'John'
    expect(page).to have_content 'Jane'
  end

  # scenario "view list of clients" do
  #   visit clients_path
  #   expect(page).to have_content 'John'
  # end
  #
  # scenario "edit client" do
  #   visit edit_client_path(test_client.id)
  #   expect(page).to have_content 'Edit'
  #   fill_in('client_first_name', :with => 'Jon')
  #   click_button('Submit')
  #   expect(page).to have_content 'Jon'
  # end
end
