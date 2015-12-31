class MatchRequestsController < ApplicationController
  def update
    load_match_request
    @match_request.update!(match_request_params)
    set_parent_proposal_to_accepted if @match_request.status == 'accepted'
    create_match if first_request_accepted?
    redirect_to @match_request.match_proposal
  end

  private

  def create_match
    match_proposal = @match_request.match_proposal
    fail 'A match already exists for this match proposal' if @match_request.match

    Match.create(
      match_request_id: @match_request.id,
      client_id: match_proposal.client_id,
      volunteer_id: @match_request.volunteer_id,
      day: match_proposal.day,
      start_time: match_proposal.start_time,
      end_time: match_proposal.end_time
    )
  end

  def set_parent_proposal_to_accepted
    @match_request.match_proposal.update!(status: 'accepted')
  end

  def first_request_accepted?
    !@match_request.match && match_request_params[:status] == 'accepted'
  end

  def load_match_request
    @match_request = MatchRequest.find(params[:id])
  end

  def match_request_params
    params.permit(:match_request, :status, :volunteer_id)
  end
end
