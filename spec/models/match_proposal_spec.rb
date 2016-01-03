require 'rails_helper'

describe MatchProposal do
  describe 'validations' do
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

    it 'validates that proposal has match requests' do
      match_proposal = build_match_proposal(build_match_requests: false)
      p match_proposal.valid?
      expect(match_proposal).to_not be_valid
    end
  end

  describe '#match' do
    it 'returns the correct match' do
      match_proposal = build_match_proposal(build_match_requests: true)
      test_match = Match.create(client_id: 1, volunteer_id: 1, day: 'monday', start_time: 0, end_time: 24, match_request_id: match_proposal.match_requests.first.id)

      expect(match_proposal.match).to eql(test_match)
    end
  end

  def build_match_proposal(start_time: 0, end_time: 24, day: 'monday', build_match_requests: true)
    match_proposal = MatchProposal.new(start_time: start_time, end_time: end_time, day: day)
    match_proposal.match_requests.new(volunteer_id: 1, status: 'pending') if build_match_requests
    match_proposal
  end
end
