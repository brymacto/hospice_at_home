require 'rails_helper'

RSpec.describe VolunteersController, type: :controller do
  let(:test_volunteer) do
    create(:volunteer)
  end

  describe 'availability POST' do
    it 'redirects user to volunteer edit page and displays flash message when there are validation errors' do
      post(:add_volunteer_availabilities,
           id: test_volunteer.id,
           availability: { start_time: 9, end_time: 10, day: '' }
          )

      expect(flash[:error]).to eq("Day can't be blank")
    end
  end

  describe '#add_volunteer_availabilities' do
    it 'does not add invalid availability' do
      get :add_volunteer_availabilities, id: test_volunteer.id, availability: { start_time: '9', end_time: '8', day: 'monday', volunteer_id: test_volunteer.id }
      expect(assigns[:availabilities].size).to eq(0)
      expect(flash[:error]).to eq('Start time must be before end time')
    end

    it 'adds valid availability' do
      post :add_volunteer_availabilities, id: test_volunteer.id, availability: { start_time: '9', end_time: '10', day: 'monday', volunteer_id: test_volunteer.id }
      expect(assigns[:availabilities].size).to eq(1)
    end

    it 'redirects to volunteer show view' do
      get :add_volunteer_availabilities, id: test_volunteer.id, availability: { start_time: '9', end_time: '10', day: 'monday', volunteer_id: test_volunteer.id }
      expect(response).to redirect_to(volunteer_path(test_volunteer))
    end
  end

  describe '#add_volunteer_specialty' do
    let(:test_specialty) do
      create(:volunteer_specialty)
    end

    it 'adds a volunteer specialty' do
      expect(test_volunteer.volunteer_specialties.count).to eq(0)
      patch :add_volunteer_specialty, id: test_volunteer.id, volunteer: { volunteer_specialty_ids: test_specialty.id }
      expect(test_volunteer.volunteer_specialties.count).to eq(1)
    end
  end

  describe '#remove_volunteer_specialty' do
    let(:test_specialty) do
      create(:volunteer_specialty)
    end

    let(:test_volunteer) do
      create(:volunteer, volunteer_specialties: [test_specialty])
    end

    it 'removes volunteer specialty' do
      expect(test_volunteer.volunteer_specialties.count).to eq(1)
      get :remove_volunteer_specialty, id: test_volunteer.id, volunteer: { volunteer_specialty_ids: test_specialty.id }
      expect(test_volunteer.volunteer_specialties.count).to eq(0)
    end

    it 'redirects to volunteer show view' do
      get :remove_volunteer_specialty, id: test_volunteer.id, volunteer: { volunteer_specialty_ids: test_specialty.id }
      expect(response).to redirect_to(volunteer_path(test_volunteer))
    end
  end
end
