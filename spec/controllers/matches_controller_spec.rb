require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  describe 'GET #explorer' do
    it 'includes no volunteers when no search params are included' do
      get :explorer

      expect(assigns(:volunteers)).to be_nil
    end

    describe '@volunteers returned by match explorer search results' do
      let!(:test_volunteer_available) do
        create(:volunteer)
      end

      let!(:test_volunteer_specialty) do
        create(:specialty)
      end

      let!(:test_volunteer_with_specialty) do
        create(:volunteer, specialties: [test_volunteer_specialty])
      end

      let!(:test_volunteer_not_available) do
        create(:volunteer)
      end

      before(:each) do
        create(:availability,
               volunteer_id: test_volunteer_available.id,
               day: 'monday',
               start_time: 10,
               end_time: 24)
        create(:availability,
               volunteer_id: test_volunteer_with_specialty.id,
               day: 'monday',
               start_time: 10,
               end_time: 24)
      end

      it 'assigns @volunteers correctly based on availability search params' do
        get :explorer, match_exploration: { day: 'monday', start_time: 10, end_time: 12, client_id: 1 }

        expect(assigns(:volunteers)).to include(test_volunteer_available)
        expect(assigns(:volunteers)).to_not include(test_volunteer_not_available)
      end

      it 'assigns @volunteers correctly based on specialty search params' do
        get :explorer, match_exploration: { day: 'monday', start_time: 10, end_time: 12, client_id: 1, specialty_id: test_volunteer_specialty.id }

        expect(assigns(:volunteers)).to include(test_volunteer_with_specialty)
        expect(assigns(:volunteers)).to_not include(test_volunteer_available)
        expect(assigns(:volunteers)).to_not include(test_volunteer_not_available)
      end

      it 'assigns empty @volunteers when none match search params based on availability' do
        get :explorer, match_exploration: { day: 'tuesday', start_time: 10, end_time: 12, client_id: 1 }

        expect(assigns(:volunteers)).to be_empty
      end

      it 'assigns empty @volunteers when none match search params based on specialty' do
        get :explorer, match_exploration: { day: 'monday', start_time: 10, end_time: 12, client_id: 1, specialty_id: test_volunteer_specialty.id + 1 }

        expect(assigns(:volunteers)).to be_empty
      end
    end
  end

  describe 'GET #index' do
    let!(:test_match) do
      create(:match,
             volunteer_id: 1,
             client_id: 1,
             day: 'monday',
             start_time: 10,
             end_time: 24)
    end

    it 'returns JSON when requested' do
      get :index, format: :json
      expect(JSON.parse(response.body)[0]['id']).to eql(test_match.id)
    end
  end
end
