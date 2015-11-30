require 'rails_helper'

RSpec.describe VolunteersController, type: :controller do
  describe 'volunteer availability POST' do
    it 'redirects user to volunteer edit page and displays flash message when there are validation errors' do
      # availability = VolunteerAvailability.new(start_hour: 9, end_hour: 10, day: nil)

      test_volunteer = create(:volunteer)

      post :add_volunteer_availabilities, id: test_volunteer.id, volunteer_availability: { start_hour: 9, end_hour: 10, day: '' }

      expect(flash[:error]).to eq('You must include day')
    end
  end
end
