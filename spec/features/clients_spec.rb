require 'rails_helper'
feature 'feature: clients' do
  let!(:test_client) { create(:client, first_name: 'Johnny') }
  scenario 'add a client' do
    visit new_client_path

    fill_in('client_first_name', with: 'Joe')
    fill_in('client_last_name', with: 'Doe')
    click_button('Submit')
    expect(page.status_code).to be(200)
    expect(page).to have_content 'Joe'
  end

  scenario 'view list of clients' do
    visit clients_path
    expect(page.status_code).to be(200)
    expect(page).to have_content 'Johnny'
  end

  scenario 'edit client' do
    visit edit_client_path(test_client.id)
    expect(page).to have_content 'Edit'
    fill_in('client_first_name', with: 'Jon')
    click_button('Submit')
    expect(page.status_code).to be(200)
    expect(page).to have_content 'Jon'
  end

  scenario 'view list of clients' do
    visit clients_path
    expect(page.status_code).to be(200)
    expect(page).to have_content test_client.first_name
  end

  scenario 'edit client' do
    visit edit_client_path(test_client.id)
    expect(page).to have_content 'Edit'
    fill_in('client_first_name', with: 'Jon')
    click_button('Submit')
    expect(page.status_code).to be(200)
    expect(page).to have_content 'Jon'
  end

  scenario 'delete client' do
    visit clients_path
    expect(page).to have_content test_client.first_name
    visit edit_client_path(test_client.id)
    click_link('Delete')
    visit clients_path
    expect(page.status_code).to be(200)
    expect(page).to have_no_content test_client.first_name
  end
end
