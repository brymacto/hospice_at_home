class MatchRequestsController < ApplicationController
  def update
    load_match_request
    @match_request.update!(match_request_params)
    set_parent_proposal_to_accepted if @match_request.status == 'accepted'
    redirect_to @match_request.match_proposal
  end

  private

  def set_parent_proposal_to_accepted
    @match_request.match_proposal.update!({ status: 'accepted' })
  end

  def create_match_request?
    !@match_request.match && match_request_params[:status] == 'accepted'
  end

  def load_match_request
    @match_request = MatchRequest.find(params[:id])
  end

  def match_request_params
    params.permit(:match_request, :status, :volunteer_id)
  end
end
