require 'rails_helper'
feature 'volunteers' do
  let!(:test_volunteer) { create(:volunteer) }
  let!(:test_volunteer_availability) do
    create(:volunteer_availability,
           volunteer_id: test_volunteer.id,
           day: 'monday',
           start_hour: 13,
           end_hour: 14)
  end
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
  feature 'volunteer availabilities' do
    scenario 'add volunteer availability' do
      visit edit_volunteer_path(test_volunteer.id)
      fill_in('volunteer_availability_start_hour', with: '9')
      fill_in('volunteer_availability_end_hour', with: '10')
      select('Monday', from: 'volunteer_availability_day')
      click_button('Add availability')
      expect(page).to have_content 'Monday'
      expect(page).to have_content '9'
      expect(page).to have_content '10'
    end

    scenario 'edit volunteer availability' do
      visit volunteer_path(test_volunteer_availability.volunteer.id)
      expect(page).to have_content 'Monday'
      expect(page).to have_content '13'
      expect(page).to have_content '14'
      visit edit_volunteer_availability_path(test_volunteer_availability.id)
      select('Wednesday', from: 'volunteer_availability_day')
      fill_in('volunteer_availability_start_hour', with: '15')
      fill_in('volunteer_availability_end_hour', with: '16')
      click_button('Submit')
      visit volunteer_path(test_volunteer_availability.volunteer.id)
      expect(page).to have_content 'Wednesday'
      expect(page).to have_content '15'
      expect(page).to have_content '16'
    end
  end
end
