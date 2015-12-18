require 'rails_helper'

describe MatchProposal do
  it 'recognizes valid MatchProposal' do
    match_proposal = build_match_proposal

    expect(match_proposal).to be_valid
  end

  it 'validates that start_time precedes end_time' do
    match_proposal = build_match_proposal(start_time: 1, end_time: 1)

    expect(match_proposal).to_not be_valid
  end

  it 'validates that day is an actual day' do
    match_proposal = build_match_proposal(day: 'foo')

    expect(match_proposal).to_not be_valid
  end

  def build_match_proposal(start_time = 0, end_time = 24, day = 'monday')
    MatchProposal.new(start_time: start_time, end_time: end_time, day: day)
  end
end

