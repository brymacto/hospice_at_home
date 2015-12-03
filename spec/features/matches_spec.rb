require 'rails_helper'
feature 'feature: matches' do
  let!(:test_client) { create(:client, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name) }
  let!(:test_volunteer) { create(:volunteer, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name) }
  scenario 'add a match' do
    visit new_match_path
    select(test_client.name, from: 'match_client_id')
    select(test_volunteer.name, from: 'match_volunteer_id')
    click_button('Submit')
    expect(page).to have_content test_client.first_name
    expect(page).to have_content test_volunteer.first_name
    expect(page).to_not have_content 'is not a number'
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

feature 'feature: Matches Explorer' do
  let!(:test_volunteer_available) do
    create(:volunteer,
           first_name: Faker::Name.first_name,
           last_name: Faker::Name.last_name)
  end
  let!(:test_volunteer_not_available) do
    create(:volunteer,
           first_name: Faker::Name.first_name,
           last_name: Faker::Name.last_name)
  end
  let!(:test_volunteer_availability) do
    create(:volunteer_availability,
           volunteer_id: test_volunteer_available.id,
           day: 'monday',
           start_hour: 10,
           end_hour: 24)
  end

  scenario 'displays validation message when field blank' do
    visit matches_explorer_path
    select('Monday', from: 'match_exploration_day')
    fill_in('match_exploration_start_time', with: '10')
    click_button('Explore Matches')
    expect(page).to have_content "End time can't be blank"
  end

  scenario 'doesnt displays validation message when form hasnt been submitted' do
    # @match_exploration isnt valid when page first loads because it has nil values.
    # This tests the logic that hides this message when user first lands on the page.
    visit matches_explorer_path
    expect(page).to_not have_content "End time can't be blank"
  end

  scenario 'returns correct results when searching for a time range' do
    visit matches_explorer_path
    select('Monday', from: 'match_exploration_day')
    fill_in('match_exploration_start_time', with: '10')
    fill_in('match_exploration_end_time', with: '12')
    click_button('Explore Matches')
    expect(page).to have_content test_volunteer_available.first_name
    expect(page).to_not have_content test_volunteer_not_available.first_name
  end
end
