feature "clients" do
  scenario "add a client" do
    visit new_client_path
    fill_in('client_first_name', :with => 'John')
    fill_in('client_last_name', :with => 'Doe')
    click_button('Submit')
    visit '/clients/1'
    expect(page).to have_content 'John'
  end
end 
