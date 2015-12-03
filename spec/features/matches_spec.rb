require 'rails_helper'
feature 'feature: matches' do
  let!(:test_client) { create(:client, first_name: 'Jonathan', last_name: 'Doe') }
  let!(:test_volunteer) { create(:volunteer, first_name: 'Susan', last_name: 'Smith') }
  let!(:test_match) do
    create(:match,
           client_id: test_client.id,
           volunteer_id: test_volunteer.id,
           day: 'monday',
           start_time: 9,
           end_time: 10)
  end
  scenario 'add a match' do
    visit new_match_path
    select(test_client.name, from: 'match_client_id')
    select(test_volunteer.name, from: 'match_volunteer_id')
    fill_in('match_start_time', with: '9')
    fill_in('match_end_time', with: '10')
    click_button('Submit')
    expect(page.status_code).to be(200)
    expect(page).to have_content 'Jonathan'
    expect(page).to have_content 'Susan'
    expect(page).to_not have_content 'is not a number'
  end

  scenario 'edit a match - form loads correctly' do
    visit edit_match_path(test_match)
    expect(page.status_code).to be(200)
    expect(find_field('match_start_time').value).to eq '9'
    expect(find_field('match_end_time').value).to eq '10'
    expect(find_field('match_day').value).to eq 'monday'
    expect(find_field('match_client_id').value).to eq test_client.id.to_s
    expect(find_field('match_volunteer_id').value).to eq test_volunteer.id.to_s
  end

  scenario 'edit a match - saves and displays correctly' do
    visit edit_match_path(test_match)
    expect(page.status_code).to be(200)
    fill_in('match_start_time', with: '12')
    fill_in('match_end_time', with: '13')
    click_button('Submit')
    expect(page.status_code).to be(200)
    expect(page).to have_content 'Monday, 12 to 13'
  end

  scenario 'delete a match' do
    visit edit_match_path(test_match)
    click_link 'Delete'
    visit match_path(test_match)
    expect(page.status_code).to be(404)
  end
end
