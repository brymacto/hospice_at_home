require 'rails_helper'

describe CreateMatchProposal do
  it 'saves a valid match proposal' do
    params = ActionController::Parameters.new({day: 'monday', start_time: 9, end_time: 10, client_id: 1, status: 'pending'})

    expect {
      CreateMatchProposal.new(params)
    }.to change {
      MatchProposal.count
    }.by(1)
  end

  it 'doesnt save a non-valid match proposal'  do
    params = ActionController::Parameters.new({day: 'monday', start_time: nil, end_time: 10, client_id: 1, status: 'pending'})

    expect {
      CreateMatchProposal.new(params)
    }.to change {
      MatchProposal.count
    }.by(0)
  end
end