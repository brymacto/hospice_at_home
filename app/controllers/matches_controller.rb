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
    load_match(new: false)
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  def new
    load_match(new: true)
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  def explorer
    load_match(new: true)
    @match_params = params[:match_exploration]
    @match_exploration = MatchExploration.new(@match_params)
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
    @match_proposal = MatchProposal.new
    load_volunteers(@match_exploration.valid?)
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
    load_match
    @match.destroy
    redirect_to matches_path
  end

  def update
    load_match
    if @match.update(match_params)
      redirect_to @match
    else
      render 'edit'
    end
  end

  private

  def load_match(new: false)
    if new == true
      @match = Match.new
      return
    end
    @match = Match.find(params[:id])
  end

  def load_matches
    load_volunteer_and_client
    if @volunteer
      @matches = Match.where(volunteer_id: @volunteer.id).includes(:client, :volunteer).order('clients.last_name ASC')
    elsif @client
      @matches = Match.where(client_id: @client.id).includes(:client, :volunteer).order('clients.last_name ASC')
    else
      @matches = Match.all.includes(:client, :volunteer).order('clients.last_name ASC')
    end
  end

  def load_volunteer_and_client
    @volunteer = Volunteer.find(params[:volunteer_id]) if params[:volunteer_id]
    @client = Client.find(params[:client_id]) if params[:client_id]
  end

  def load_volunteers(match_exploration_valid)
    return unless match_exploration_valid

    @volunteers = Volunteer.joins(:volunteer_availabilities).where(
      "volunteer_availabilities.start_hour <= :start_time AND
      volunteer_availabilities.end_hour >= :end_time AND
      volunteer_availabilities.day = :day",
      start_time: search_time_range.start_time,
      end_time: search_time_range.end_time,
      day: search_time_range.day).distinct.order(:last_name)
  end

  def search_time_range
    TimeRange.new(
      @match_exploration.day,
      @match_exploration.start_time,
      @match_exploration.end_time)
  end

  def time_range_params?
    params[:day] && params[:start_time] && params[:end_time]
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
