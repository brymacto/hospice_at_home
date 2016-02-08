require 'rails_helper'
feature 'feature: specialties' do
  let!(:test_specialty) { create(:volunteer_specialty, name: 'Expressive Arts') }

  scenario 'view list of specialties' do
    visit volunteer_specialties_path

    expect(page.status_code).to be(200)
    expect(page).to have_css('td', text: 'Expressive Arts')
  end

  scenario 'add specialty' do
    visit volunteer_specialties_path
    click_link('New specialty')
    fill_in('volunteer_specialty_name', with: 'Bereavement')

    click_button('Submit')

    expect(page.status_code).to be(200)
    expect(page).to have_css('td', text: 'Bereavement')
  end

  scenario 'edit specialty' do
    visit edit_volunteer_specialty_path(test_specialty)
    fill_in('volunteer_specialty_name', with: 'Catholicism')

    click_button('Submit')

    expect(page.status_code).to be(200)
    expect(page).to_not have_css('td', text: 'Expressive Arts')
    expect(page).to have_css('td', text: 'Catholicism')
  end

  scenario 'delete specialty' do
    visit edit_volunteer_specialty_path(test_specialty)

    click_link('Delete this specialty')

    expect(page.status_code).to be(200)
    expect(page).to_not have_css('td', text: 'Expressive Arts')
  end
end
