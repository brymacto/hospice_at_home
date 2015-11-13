require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
feature "clients" do
  before(:each) do
    DatabaseCleaner.clean
  end
  let!(:test_client) { create(:client) }
  scenario "add a client" do
    visit new_client_path
    fill_in('client_first_name', :with => 'John')
    fill_in('client_last_name', :with => 'Doe')
    click_button('Submit')
    expect(page).to have_content 'John'
  end

  scenario "view list of clients" do
    visit clients_path
    expect(page).to have_content 'John'
  end

  scenario "edit client" do
    visit edit_client_path(test_client.id)
    expect(page).to have_content 'Edit'
    fill_in('client_first_name', :with => 'Jon')
    click_button('Submit')
    expect(page).to have_content 'Jon'
  end
end 
