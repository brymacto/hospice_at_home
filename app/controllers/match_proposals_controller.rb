class MatchProposalsController < ApplicationController
  def create
    @match_proposal = MatchProposal.new(match_proposal_params)
    @match_proposal.save

    match_request_volunteer_ids.each do |volunteer_id|
      MatchRequest.create!(volunteer_id: volunteer_id, status: 'pending', match_proposal_id: @match_proposal.id)
    end

    if @match_proposal.save
      redirect_to @match_proposal
    else
      flash.now[:error] = @match_proposal.errors.full_messages.to_sentence
      # render 'new'
    end
  end

  def show
    @match_proposal = MatchProposal.find(params[:id])
  end


  private

  def match_request_volunteer_ids
    params.keys.
      select { |param| param.include?('select_for_email_') }.
      map { |param| param.split('_').last }
  end

  def match_proposal_params
    params.permit(:day, :start_time, :end_time, :client_id, :status).merge(client_id: params[:match_proposal][:client_id], status: 'pending')
  end
end
