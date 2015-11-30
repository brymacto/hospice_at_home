require 'rails_helper'
feature 'volunteers' do

  let!(:test_volunteer) { create(:volunteer) }
  scenario 'add a volunteer' do
    visit new_volunteer_path
    fill_in('volunteer_first_name', with: 'Jane')
    fill_in('volunteer_last_name', with: 'Doe')
    click_button('Submit')
    expect(page).to have_content 'Jane'
  end

  scenario 'view list of volunteers' do
    visit volunteers_path
    expect(page).to have_content 'Jane'
  end

  scenario 'edit volunteer' do
    visit edit_volunteer_path(test_volunteer.id)
    expect(page).to have_content 'Edit'
    fill_in('volunteer_first_name', with: 'Sara Jane')
    click_button('Submit')
    expect(page).to have_content 'Sara Jane'
  end

  scenario 'add volunteer availability' do
    visit edit_volunteer_path(test_volunteer.id)
    fill_in('volunteer_availability_start_hour', with: '9')
    fill_in('volunteer_availability_end_hour', with: '10')
    select('Monday', :from => 'volunteer_availability_day')
    click_button('Add availability')
    expect(page).to have_content 'Monday'
    expect(page).to have_content '9'
    expect(page).to have_content '10'
  end
end
