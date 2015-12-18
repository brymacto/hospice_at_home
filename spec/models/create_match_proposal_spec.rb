require 'rails_helper'

describe CreateMatchProposal do
  it 'saves a valid match proposal' do
    params = build_params

    expect {
      CreateMatchProposal.new(params)
    }.to change {
      MatchProposal.count
    }.by(1)
  end

  it 'does not save a invalid match proposal'  do
    params = build_params.merge(start_time: nil)

    expect {
      CreateMatchProposal.new(params)
    }.to change {
      MatchProposal.count
    }.by(0)
  end

  def build_params
    ActionController::Parameters.new({day: 'monday', start_time: 9, end_time: 10, client_id: 1, status: 'pending'})
  end
end