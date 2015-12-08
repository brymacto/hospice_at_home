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

  scenario 'displays validation message when field blank' do
    visit matches_explorer_path
    select('Monday', from: 'match_exploration_day')
    fill_in('match_exploration_start_time', with: '10')
    click_button('Explore Matches')
    expect(page.status_code).to be(200)
    expect(page).to have_content "End time can't be blank"
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

  scenario 'displays match creation form when explorer returns volunteers' do
    visit matches_explorer_path
    select('Monday', from: 'match_exploration_day')
    fill_in('match_exploration_start_time', with: '10')
    fill_in('match_exploration_end_time', with: '11')
    click_button('Explore Matches')
    expect(page.status_code).to be(200)
    expect(page).to have_selector('form#new_match')
  end

  scenario 'creates match from explorer' do
    visit matches_explorer_path
    select('Monday', from: 'match_exploration_day')
    fill_in('match_exploration_start_time', with: '10')
    fill_in('match_exploration_end_time', with: '11')
    click_button('Explore Matches')
    select(test_volunteer_available.name, from: 'match_volunteer_id')
    select(test_client.name, from: 'match_client_id')
    click_button('Create match')
    expect(page.status_code).to be(200)
    expect(page).to have_content(test_volunteer_available.name)
    expect(page).to have_content(test_client.name)
  end

  scenario 'displays validation error when new match form not filled in on match explorer' do
    visit matches_explorer_path
    select('Monday', from: 'match_exploration_day')
    fill_in('match_exploration_start_time', with: '10')
    fill_in('match_exploration_end_time', with: '11')
    click_button('Explore Matches')
    click_button('Create match')
    expect(page.status_code).to be(200)
    expect(page).to have_content('Matches Explorer')
    expect(page).to have_content('be blank')
    expect(page).to have_selector('#flash')
  end
end
