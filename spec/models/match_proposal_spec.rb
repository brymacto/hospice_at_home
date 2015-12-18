require 'rails_helper'

describe MatchProposal do
  it 'recognizes valid MatchProposal' do
    match_proposal = MatchProposal.new(start_time: 0, end_time: 1, day: 'foo')

    expect(match_proposal).to be_valid
  end

  it 'validates that start_time is number' do
    match_proposal = MatchProposal.new(start_time: 'a', end_time: 1, day: 'foo')

    expect(match_proposal).to_not be_valid
  end

  it 'validates that start_time is between 0 and 23' do
    match_proposal = MatchProposal.new(start_time: -1, end_time: 24, day: 'foo')
    expect(match_proposal).to_not be_valid

    match_proposal = MatchProposal.new(start_time: 0, end_time: 24, day: 'foo')
    expect(match_proposal).to be_valid

    match_proposal = MatchProposal.new(start_time: 23, end_time: 24, day: 'foo')
    expect(match_proposal).to be_valid

    match_proposal = MatchProposal.new(start_time: 24, end_time: 24, day: 'foo')
    expect(match_proposal).to_not be_valid
  end

  it 'validates that end_time is number' do
    match_proposal = MatchProposal.new(start_time: 0, end_time: 'a', day: 'foo')

    expect(match_proposal).to_not be_valid
  end

  it 'validates that end_time is between 1 and 24' do
    match_proposal = MatchProposal.new(start_time: 0, end_time: 0, day: 'foo')
    expect(match_proposal).to_not be_valid

    match_proposal = MatchProposal.new(start_time: 0, end_time: 1, day: 'foo')
    expect(match_proposal).to be_valid

    match_proposal = MatchProposal.new(start_time: 0, end_time: 24, day: 'foo')
    expect(match_proposal).to be_valid

    match_proposal = MatchProposal.new(start_time: 0, end_time: 25, day: 'foo')
    expect(match_proposal).to_not be_valid
  end

  it 'validates day is present' do
    match_proposal = MatchProposal.new(start_time: 0, end_time: 24, day: '')

    expect(match_proposal).to_not be_valid
  end

  it 'validates that start_time precedes end_time' do
    match_proposal = MatchProposal.new(start_time: 1, end_time: 1, day: 'foo')

    expect(match_proposal).to_not be_valid
  end
end

