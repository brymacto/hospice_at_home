require 'rails_helper'

RSpec.describe MatchRequestsController, type: :controller do
  let!(:test_volunteer) do
    create(:volunteer)
  end

  let!(:test_client) do
    create(:client)
  end

  let(:test_match_proposal) do
    create(:match_proposal,
           client_id: test_client.id,
           match_requests:
      [
        create(:match_request,
               volunteer_id: test_volunteer.id,
               status: 'pending'),
        create(:match_request,
               volunteer_id: test_volunteer.id + 1,
               status: 'pending')
      ]
          )
  end

  let(:test_match_request) do
    test_match_proposal.match_requests.first
  end

  let(:test_match_request_2) do
    test_match_proposal.match_requests.last
  end

  describe 'PUT #update' do
    it 'creates a match when status set to accepted' do
      expect do
        put :update, id: test_match_request.id, status: 'accepted'
      end.to change { Match.all.size }.by(1)
    end

    it 'does not create a match when status set to rejected' do
      expect do
        put :update, id: test_match_request.id, status: 'rejected'
      end.to_not change { Match.all.size }
    end

    it 'creates 1 match only when trying to accept 2 for the same proposal' do
      expect do
        put :update, id: test_match_request.id, status: 'accepted'
        put :update, id: test_match_request_2.id, status: 'accepted'
      end.to change { Match.all.size }.by(1)
    end

    it 'sets parent proposal status to accepted when accepted' do
      expect do
        put :update, id: test_match_request.id, status: 'accepted'
        test_match_proposal.reload
      end.to change { test_match_proposal.status }.from('pending').to('accepted')
    end

    it 'does not set parent proposal status to accepted when rejected' do
      expect do
        put :update, id: test_match_request.id, status: 'rejected'
        test_match_proposal.reload
      end.to_not change { test_match_proposal.status }
    end

    it 'redirects user to parent match proposal after update' do
      put :update, id: test_match_request.id, status: 'rejected'

      expect(response).to redirect_to("/match_proposals/#{test_match_proposal.id}")
    end
  end
end
