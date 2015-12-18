require 'rails_helper'

describe CreateMatchProposal do

  it 'creates a valid match proposal' do
    params = ActionController::Parameters.new({day: 'monday', start_time: 9, end_time: 10, client_id: 1, status: 'pending'})
    initial_count = MatchProposal.count
    service = CreateMatchProposal.new(params)

    expect(MatchProposal.count - initial_count).to be(1)
  end
end