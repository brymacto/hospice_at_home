require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
feature "volunteers" do
  before(:each) do
    DatabaseCleaner.clean
  end
  let!(:test_volunteer) { create(:volunteer) }
  scenario "add a volunteer" do
    visit new_volunteer_path
    fill_in('volunteer_first_name', :with => 'Jane')
    fill_in('volunteer_last_name', :with => 'Doe')
    click_button('Submit')
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
