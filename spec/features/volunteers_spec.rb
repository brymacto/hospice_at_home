require 'rails_helper'
feature 'feature: volunteers' do
  let!(:test_volunteer) { create(:volunteer, first_name: 'John', last_name: 'Smith') }

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

    expect(page.status_code).to be(200)
    expect(page).to have_content 'Jane'
  end

  scenario 'view list of volunteers' do
    visit volunteers_path

    expect(page.status_code).to be(200)
    expect(page).to have_content test_volunteer.name
  end

  scenario 'edit volunteer' do
    visit edit_volunteer_path(test_volunteer.id)
    expect(page).to have_content 'Edit'
    fill_in('volunteer_first_name', with: 'Sara Jane')

    click_button('Submit')

    expect(page.status_code).to be(200)
    expect(page).to have_content 'Volunteer: Sara Jane Smith'
  end

  feature 'volunteer specialties' do
    scenario 'add specialty to volunteer' do
      create(:volunteer_specialty, name: 'Expressive Arts')
      visit volunteer_path(test_volunteer.id)
      select('Expressive Arts', from: 'volunteer_volunteer_specialty_ids')

      click_button('add_specialty')

      expect(page).to have_css('span.specialty a', text: 'Expressive Arts')

      page.find('span.specialty a.remove_specialty').click
      expect(page).to_not have_css('span.specialty a', text: 'Expressive Arts')
    end

    scenario 'remove specialty from volunteer' do
      create(:volunteer_specialty, name: 'Expressive Arts')
      visit volunteer_path(test_volunteer.id)
      select('Expressive Arts', from: 'volunteer_volunteer_specialty_ids')

      click_button('add_specialty')

      expect(page).to have_css('span.specialty a', text: 'Expressive Arts')


    end
  end

  feature 'volunteer availabilities' do
    scenario 'add volunteer availability' do
      visit volunteer_path(test_volunteer.id)
      fill_in_availability_form(day: 'Monday', start_time: 9, end_time: 10)

      click_button('add_availability')

      expect(page.status_code).to be(200)
      expect(page).to have_availability({day: 'Monday', start_time: 9, end_time: 10})
    end

    scenario 'add multiple volunteer availabilities that are automatically merged' do
      visit volunteer_path(test_volunteer.id)
      fill_in_availability_form(day: 'Monday', start_time: 9, end_time: 10)
      click_button('add_availability')
      fill_in_availability_form(day: 'Monday', start_time: 10, end_time: 11)

      click_button('add_availability')

      expect(page.status_code).to be(200)
      expect(page).to have_content 'The following availabilities have been merged: Monday, from 9 to 10 and from 10 to 11'
    end

    scenario 'edit volunteer availability' do
      visit volunteer_path(test_volunteer_availability.volunteer.id)

      expect(page.status_code).to be(200)
      expect(page).to have_availability({day: 'Monday', start_time: 13, end_time: 14})

      visit edit_volunteer_availability_path(test_volunteer_availability.id)
      expect(page.status_code).to be(200)


      fill_in_availability_form(day: 'Wednesday', start_time: 15, end_time: 16)

      click_button('Submit')

      visit volunteer_path(test_volunteer_availability.volunteer.id)
      expect(page.status_code).to be(200)
      expect(page).to have_availability({day: 'Wednesday', start_time: 15, end_time: 16})
    end
  end
end

def fill_in_availability_form(args = {})
  day = args[:day]
  start_time = args[:start_time].to_s
  end_time = args[:end_time].to_s

  fill_in('volunteer_availability_start_hour', with: start_time)
  fill_in('volunteer_availability_end_hour', with: end_time)
  select(day, from: 'volunteer_availability_day')
end

RSpec::Matchers::define :have_availability do |availability|
  day = availability[:day].capitalize
  start_time = availability[:start_time].to_s
  end_time = availability[:end_time].to_s

  match do |page|
    page.find('#availability_table tr:nth-child(2) td.availability_table_day').has_content?(day) &&
      page.find('#availability_table tr:nth-child(2) td.availability_table_start_time').has_content?(start_time) &&
      page.find('#availability_table tr:nth-child(2) td.availability_table_end_time').has_content?(end_time)
  end
end