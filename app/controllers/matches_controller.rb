class MatchesController < ApplicationController
  def create
    @match = Match.new(match_params)
    if @match.save
      redirect_to @match
    else
      flash.now[:error] = @match.errors.full_messages.to_sentence
      @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
      render_after_create(params[:from_match_explorer])
    end
  end

  def show
    service = LoadMatchService.new(params, load_collection: false)
    @match = service.match
    @match_proposal = service.match_proposal
  end

  def edit
    service = LoadMatchService.new(params, load_collection: false)
    @match = service.match
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  def new
    load_new_match
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  def explorer
    load_new_match
    @match_exploration_params = params[:match_exploration]
    service = MatchExplorerService.new(@match_exploration_params)
    @match_exploration = service.match_exploration
    @day_options = service.day_options
    @match_proposal = MatchProposal.new
    @volunteers = service.volunteers
  end

  def index
    service = LoadMatchService.new(params, load_collection: true)
    @matches = service.matches
    @match_proposals = service.match_proposals
    @no_turbolinks = true
    @initial_tab = params[:initial_tab]
    respond_to do |format|
      format.html
      format.json { render json: @matches }
    end
  end

  def destroy
    service = LoadMatchService.new(params, load_collection: false)
    @match = service.match
    @match.destroy
    redirect_to matches_path
  end

  def update
    service = LoadMatchService.new(params, load_collection: false)
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
                                     :end_time]
    )
  end

  def render_after_create(from_match_explorer)
    render from_match_explorer ? matches_explorer_path : new_match_path
  end
end
