class MatchProposalsController < ApplicationController
  include BreadcrumbGenerator

  def create
    service = CreateMatchProposal.new(params)
    if service.successful?
      @match_proposal = service.match_proposal
      redirect_to @match_proposal
    else
      flash.now[:error] = service.error_messages
      @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
      # TODO: assign @match_exploration before rendering, to maintain search.
      render 'matches/explorer'
    end
  end

  def index
    @match_proposals = MatchProposal.all
                       .includes(:client, :match_requests)
                       .order('match_proposals.status ASC')
                       .order('clients.last_name ASC')
    respond_to do |format|
      format.json { render json: @match_proposals }
    end
  end

  def show
    @match_proposal = MatchProposal.find(params[:id])
    @match_requests = @match_proposal.match_requests.includes(:volunteer).order('volunteers.last_name ASC')
    load_breadcrumbs([matches_path, 'Match proposals'], [match_proposal_path(@match_proposal), @match_proposal.name])
  end

  def destroy
    @match_proposal = MatchProposal.find(params[:id])
    @match_proposal.destroy
    redirect_to matches_path(initial_tab: 'match_proposal')
  end
end
