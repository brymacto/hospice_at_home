require 'rails_helper'

feature 'feature: Matches Explorer' do
  let!(:test_volunteer_available) do
    create(:volunteer,
           first_name: 'John',
           last_name: 'Smith')
  end

  let!(:test_volunteer_not_available) do
    create(:volunteer,
           first_name: 'Jane',
           last_name: 'Doe')
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
           first_name: 'Brian',
           last_name: 'Blaine')
  end

  let!(:test_specialty) do
    create(:volunteer_specialty,
           name: 'Expressive Arts')
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

  scenario 'does not display validation message before form has been submitted' do
    # @match_exploration is not valid when page first loads because it has nil values.
    # This tests the logic that hides this message when user first lands on the page.
    visit matches_explorer_path

    expect(page.status_code).to be(200)
    expect(page).to_not have_content "End time can't be blank"
  end

  scenario 'returns correct volunteer results when searching for a time range' do
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

  scenario 'returns no volunteer results when no volunteers match time range' do
    visit matches_explorer_path
    select('Friday', from: 'match_exploration_day')
    select(test_client.name, from: 'match_exploration_client_id')
    fill_in('match_exploration_start_time', with: '23')
    fill_in('match_exploration_end_time', with: '24')

    click_button('Explore Matches')

    expect(page.status_code).to be(200)
    expect(page).to have_content 'No volunteers match'
  end

  feature 'specialty is included in search criteria' do
    scenario 'returns no volunteer results when volunteers match time range but do not match given specialty' do
      visit matches_explorer_path
      select('Monday', from: 'match_exploration_day')
      select(test_client.name, from: 'match_exploration_client_id')
      fill_in('match_exploration_start_time', with: '10')
      fill_in('match_exploration_end_time', with: '12')
      select(test_specialty.name, from: 'match_exploration_specialty_id')

      click_button('Explore Matches')

      expect(page.status_code).to be(200)
      expect(page).to have_content 'No volunteers match your search criteria.'
      expect(page).to_not have_content test_volunteer_available.first_name
      expect(page).to_not have_content test_volunteer_not_available.first_name
    end

    scenario 'returns correct volunteer results when volunteers match time range and specialty' do
      add_specialty_to_volunteer(test_specialty, test_volunteer_available)
      visit matches_explorer_path
      select('Monday', from: 'match_exploration_day')
      select(test_client.name, from: 'match_exploration_client_id')
      fill_in('match_exploration_start_time', with: '10')
      fill_in('match_exploration_end_time', with: '12')
      select(test_specialty.name, from: 'match_exploration_specialty_id')

      click_button('Explore Matches')

      expect(page.status_code).to be(200)
      expect(page).to_not have_content 'No volunteers match your search criteria.'
      expect(page).to have_content test_volunteer_available.first_name
    end
  end

  scenario 'does not display proposal form if volunteer matches other time criteria but not specialty' do
    visit matches_explorer_path
    select('Monday', from: 'match_exploration_day')
    select(test_client.name, from: 'match_exploration_client_id')
    fill_in('match_exploration_start_time', with: '10')
    fill_in('match_exploration_end_time', with: '12')
    select(test_specialty.name, from: 'match_exploration_specialty_id')

    click_button('Explore Matches')

    expect(page.status_code).to be(200)
    expect(page).to have_content 'No volunteers match your search criteria.'
    expect(page).to_not have_content test_volunteer_available.first_name
    expect(page).to_not have_content test_volunteer_not_available.first_name
  end
end

feature 'feature: Match proposal creation from Matches Explorer' do
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

  scenario 'doesnt display match proposal creation form when explorer returns no volunteers' do
    visit matches_explorer_path
    select('Friday', from: 'match_exploration_day')
    fill_in('match_exploration_start_time', with: '10')
    fill_in('match_exploration_end_time', with: '12')

    click_button('Explore Matches')

    expect(page.status_code).to be(200)
    expect(page).to have_no_selector('input#create_proposal_button')
  end
end


def add_specialty_to_volunteer(specialty, volunteer)
  params =     ActionController::Parameters.new(
    'controller' => 'volunteers',
    'action' => 'add_volunteer_specialty',
    'volunteer' => {
      'volunteer_specialty_ids' => specialty.id.to_s
    },
    'id' => volunteer.id.to_s
  )

  service = VolunteerSpecialtyService.new(params)
  service.add_specialty_to_volunteer
end