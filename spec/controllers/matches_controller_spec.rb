require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  let!(:test_volunteer_available) do
    create(
      :volunteer,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name)
  end
  let!(:test_volunteer_not_available) do
    create(
      :volunteer,
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

  describe 'GET #explorer' do
    it 'includes no volunteers when no search params are included' do
      get :explorer

      expect(assigns(:volunteers)).to be_nil
    end

    it 'assigns @volunteers correctly based on search params' do
      get :explorer, match_exploration: { day: 'monday', start_time: 10, end_time: 12, client_id: 1 }

      expect(assigns(:volunteers)).to include(test_volunteer_available)
      expect(assigns(:volunteers)).to_not include(test_volunteer_not_available)
    end

    it 'assigns empty @volunteers when none match search params' do
      get :explorer, match_exploration: { day: 'tuesday', start_time: 10, end_time: 12, client_id: 1 }

      expect(assigns(:volunteers)).to be_empty
    end
  end
end
