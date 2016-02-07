require 'rails_helper'

feature 'Matches Explorer' do
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
    fill_in_form(day: 'Monday', start_time: 10)

    click_button('Explore Matches')

    expect(page.status_code).to be(200)
    expect(page).to have_content "End time can't be blank"
    expect(page).to have_content "Client can't be blank"
  end

  scenario 'does not display validation message before form has been submitted' do
    visit matches_explorer_path

    expect(page.status_code).to be(200)
    expect(page).to_not have_content "End time can't be blank"
  end

  scenario 'returns correct volunteer results when searching for a time range' do
    visit matches_explorer_path
    fill_in_form(day: 'Monday', start_time: 10, end_time: 12, client: test_client)

    click_button('Explore Matches')

    expect(page.status_code).to be(200)
    expect(page).to have_content test_volunteer_available.first_name
    expect(page).to_not have_content test_volunteer_not_available.first_name
  end

  scenario 'returns no volunteer results when no volunteers match time range' do
    visit matches_explorer_path
    fill_in_form(day: 'Friday', start_time: 23, end_time: 24, client: test_client)

    click_button('Explore Matches')

    expect(page.status_code).to be(200)
    expect(page).to have_content 'No volunteers match'
  end

  feature 'specialty is included in search criteria' do

    scenario 'returns no volunteer results when volunteers match time range but do not match given specialty' do
      visit matches_explorer_path
      fill_in_form(day: 'Monday', start_time: 10, end_time: 12, client: test_client, specialty: test_specialty)

      click_button('Explore Matches')

      expect(page.status_code).to be(200)
      expect(page).to have_content 'No volunteers match your search criteria.'
      expect(page).to_not have_content test_volunteer_available.first_name
      expect(page).to_not have_content test_volunteer_not_available.first_name
    end

    scenario 'returns correct volunteer results when volunteers match time range and specialty' do
      add_specialty_to_volunteer(test_specialty, test_volunteer_available)
      visit matches_explorer_path
      fill_in_form(day: 'Monday', start_time: 10, end_time: 12, client: test_client, specialty: test_specialty)

      click_button('Explore Matches')

      expect(page.status_code).to be(200)
      expect(page).to_not have_content 'No volunteers match your search criteria.'
      expect(page).to have_content test_volunteer_available.first_name
    end
  end

  feature 'Match proposal creation from Matches Explorer' do
    let!(:test_client) { create(:client, first_name: 'John', last_name: 'Smith') }

    scenario 'does not display match proposal creation form when explorer returns no volunteers' do
      visit matches_explorer_path
      fill_in_form(day: 'Friday', start_time: 10, end_time: 12)

      click_button('Explore Matches')

      expect(page.status_code).to be(200)
      expect(page).to have_no_selector('input#create_proposal_button')
    end

    scenario 'creates match proposal from explorer results' do
      visit matches_explorer_path
      fill_in_form(day: 'Monday', start_time: 10, end_time: 12, client: test_client)
      click_button('Explore Matches')
      expect(page).to have_content test_volunteer_available.first_name
      check("select_for_email_#{test_volunteer_available.id}")

      click_button('Create proposal')

      expect(page.status_code).to be(200)
      expect(page).to have_content('Match proposal for John Smith')
    end
  end
end

def fill_in_form(args = {})
  day = args[:day]
  start_time = args[:start_time].to_s
  end_time = args[:end_time].to_s
  client = args[:client]
  specialty = args[:specialty]

  select(day, from: 'match_exploration_day') if day
  select(client.name, from: 'match_exploration_client_id') if client
  select(specialty.name, from: 'match_exploration_specialty_id') if specialty
  fill_in('match_exploration_start_time', with: start_time)
  fill_in('match_exploration_end_time', with: end_time)
end

def add_specialty_to_volunteer(specialty, volunteer)
  params = ActionController::Parameters.new(
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