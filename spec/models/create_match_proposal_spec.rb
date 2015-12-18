require 'rails_helper'

describe CreateMatchProposal do
  it 'creates a valid match proposal' do
    params = ActionController::Parameters.new({day: 'monday', start_time: 9, end_time: 10, client_id: 1, status: 'pending'})

    expect {
      CreateMatchProposal.new(params)
    }.to change {
      MatchProposal.count
    }.by(1)
  end
end