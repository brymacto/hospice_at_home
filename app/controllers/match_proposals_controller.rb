class MatchProposalsController < ApplicationController
  def create
    @match_proposal = MatchProposal.new(match_proposal_params)
    if @match_proposal.save
      redirect_to @match_proposal
    else
      flash.now[:error] = @match_proposal.errors.full_messages.to_sentence
      # render 'new'
    end
  end


  private

  def match_proposal_params
    params.permit(:day, :start_time, :end_time, :client_id, :status).merge(client_id: params[:match_proposal][:client_id], status: 'pending')
  end
end
