class MatchesController < ApplicationController
  include BreadcrumbGenerator

  def create
    @match = Match.new(match_params)
    if @match.save
      redirect_to @match
    else
      flash.now[:error] = @match.errors.full_messages.to_sentence
      render_after_create(params[:from_match_explorer])
    end
  end

  def show
    service = MatchLoadingService.new(params, load_collection: false)
    @match = service.match
    @match_proposal = service.match_proposal
    load_breadcrumbs(crumb_class: Match, crumb_instance: @match)
  end

  def edit
    service = MatchLoadingService.new(params, load_collection: false)
    @match = service.match
    load_breadcrumbs(crumb_class: Match, crumb_instance: @match, crumb_actions: [:edit])
  end

  def new
    @volunteer = Volunteer.find(params[:volunteer_id]) if params[:volunteer_id]
    load_new_match
    load_breadcrumbs(crumb_class: Match, crumb_actions: [:new])
  end

  def explorer
    load_new_match
    @match_exploration_params = params[:match_exploration]
    service = MatchExplorerService.new(@match_exploration_params)
    @match_exploration = service.match_exploration
    @match_proposal = MatchProposal.new
    @volunteers = service.volunteers
    @specialty_selected_value = @match_exploration.specialty_id if @match_exploration
    load_breadcrumbs(crumb_class: Match, crumb_actions: [:match_explorer])
  end

  def index
    service = MatchLoadingService.new(params, load_collection: true)
    @matches = service.matches
    @match_proposals = service.match_proposals
    @no_turbolinks = true
    @initial_tab = params[:initial_tab]
    load_breadcrumbs(crumb_class: Match)
    respond_to do |format|
      format.html
      format.json { render json: @matches }
    end
  end

  def destroy
    service = MatchLoadingService.new(params, load_collection: false)
    @match = service.match
    @match.destroy
    redirect_to matches_path
  end

  def update
    service = MatchLoadingService.new(params, load_collection: false)
    @match = service.match
    if @match.update(match_params)
      redirect_to @match
    else
      render 'edit'
    end
  end

  private

  def load_new_match
    @match = Match.new
  end

  def match_params
    params.require(:match).permit(
      :client_id, :volunteer_id, :day, :start_time, :end_time, :from_match_explorer, :initial_tab,
      match_exploration_attributes: [:client_id,
                                     :volunteer_id,
                                     :day,
                                     :start_time,
                                     :end_time,
                                     :specialty_id]
    )
  end

  def render_after_create(from_match_explorer)
    render from_match_explorer ? matches_explorer_path : new_match_path
  end
end
