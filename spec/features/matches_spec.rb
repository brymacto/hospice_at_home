require 'rails_helper'
feature 'matches' do
  let!(:test_client) { create(:client, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name) }
  let!(:test_volunteer) { create(:volunteer, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name) }
  scenario 'add a match' do
    visit new_match_path
    select(test_client.name, from: 'match_client_id')
    select(test_volunteer.name, from: 'match_volunteer_id')
    click_button('Submit')
    expect(page).to have_content 'John'
    expect(page).to have_content 'Jane'
  end

  scenario 'view list of clients' do
    visit clients_path
    expect(page).to have_content test_client.first_name
  end

  scenario 'edit client' do
    visit edit_client_path(test_client.id)
    expect(page).to have_content 'Edit'
    fill_in('client_first_name', with: 'Jon')
    click_button('Submit')
    expect(page).to have_content 'Jon'
  end

  scenario 'delete client' do
    visit clients_path
    expect(page).to have_content test_client.first_name
    visit edit_client_path(test_client.id)
    click_link('Delete')
    visit clients_path
    expect(page).to have_no_content test_client.first_name
  end
end
