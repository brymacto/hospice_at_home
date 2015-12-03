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
end
