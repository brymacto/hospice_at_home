require 'rails_helper'

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
  let!(:test_client) do
    create(:client,
           first_name: 'Enrique',
           last_name: 'Sanchez')
  end

  scenario 'displays validation message when field blank' do
    visit matches_explorer_path
    select('Monday', from: 'match_exploration_day')
    fill_in('match_exploration_start_time', with: '10')
    click_button('Explore Matches')
    expect(page.status_code).to be(200)
    expect(page).to have_content "End time can't be blank"
    expect(page).to have_content "Client can't be blank"
  end

  scenario 'doesnt displays validation message when form hasnt been submitted' do
    # @match_exploration isnt valid when page first loads because it has nil values.
    # This tests the logic that hides this message when user first lands on the page.
    visit matches_explorer_path
    expect(page.status_code).to be(200)
    expect(page).to_not have_content "End time can't be blank"
  end

  scenario 'returns correct results when searching for a time range' do
    visit matches_explorer_path
    select('Monday', from: 'match_exploration_day')
    select(test_client.name, from: 'match_exploration_client_id')
    fill_in('match_exploration_start_time', with: '10')
    fill_in('match_exploration_end_time', with: '12')
    click_button('Explore Matches')
    expect(page.status_code).to be(200)
    expect(page).to have_content test_volunteer_available.first_name
    expect(page).to_not have_content test_volunteer_not_available.first_name
  end

  scenario 'displays message when no volunteers match given criteria' do
    visit matches_explorer_path
    select('Friday', from: 'match_exploration_day')
    select(test_client.name, from: 'match_exploration_client_id')
    fill_in('match_exploration_start_time', with: '23')
    fill_in('match_exploration_end_time', with: '24')
    click_button('Explore Matches')
    expect(page.status_code).to be(200)
    expect(page).to have_content 'No volunteers match'
  end
end

feature 'feature: Match creation from Matches Explorer' do
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

  let!(:test_client) { create(:client, first_name: 'John', last_name: 'Smith') }

  scenario 'doesnt display match creation form when explorer returns no volunteers' do
    visit matches_explorer_path
    select('Friday', from: 'match_exploration_day')
    fill_in('match_exploration_start_time', with: '23')
    fill_in('match_exploration_end_time', with: '24')
    click_button('Explore Matches')
    expect(page.status_code).to be(200)
    expect(page).to have_no_selector('form#new_match')
  end
end
