class MatchProposalsController < ApplicationController
  def create
    service = CreateMatchProposal.new(params)
    if service.successful?
      @match_proposal = service.match_proposal
      redirect_to @match_proposal
    else
      flash.now[:error] = service.error_messages
      @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
      #TODO: assign @match_exploration before rendering, to maintain search.
      render 'matches/explorer'
    end
  end

  def show
    @match_proposal = MatchProposal.find(params[:id])
    @match_requests = @match_proposal.match_requests.includes(:volunteer).order('volunteers.last_name ASC')
  end

  def destroy
    @match_proposal = MatchProposal.find(params[:id])
    @match_proposal.destroy
    redirect_to matches_path(initial_tab: 'match_proposal')
  end

end