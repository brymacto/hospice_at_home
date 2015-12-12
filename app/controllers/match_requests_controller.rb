class MatchRequestsController < ApplicationController

  def update
    load_match_request
    @match_request.update!(match_request_params)
    redirect_to @match_request.match_proposal
  end

  private

  def load_match_request
    @match_request = MatchRequest.find(params[:id])
  end

  def match_request_params
    params.permit(:match_request, :status)
  end

end