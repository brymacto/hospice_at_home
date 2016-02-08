require 'rails_helper'

describe MatchProposalCreationService do
  it 'saves a valid match proposal' do
    params = build_params

    expect do
      described_class.new(params)
    end.to change {
      MatchProposal.count
    }.by(1)
  end

  it 'saves match requests' do
    params = build_params
    mp = described_class.new(params).match_proposal
    mr = mp.match_requests
    expect(mr.size).to eq(1)
  end

  it 'does not save a invalid match proposal' do
    params = build_params.merge(start_time: nil)

    expect do
      described_class.new(params)
    end.to change {
      MatchProposal.count
    }.by(0)
  end

  def build_params
    ActionController::Parameters.new(
      day: 'monday',
      start_time: 9,
      end_time: 10,
      client_id: 1,
      status: 'pending',
      match_requests_attributes: {
        '0' => {
          volunteer_id: 1,
          status: 'pending'
        }
      }
    )
  end
end
