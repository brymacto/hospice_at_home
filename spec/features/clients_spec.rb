feature "clients" do
  scenario "add a client" do
    visit 'new_clients_path'
    fill_in('First Name', :with => 'John')
    fill_in('First Name', :with => 'Doe')
    click_button('Submit')
    visit '/clients/1'
    expect(page).to have_content 'John'
  end
end 
