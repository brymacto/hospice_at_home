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
    load_match_from_params
  end

  def edit
    load_match_from_params
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  def new
    load_match_new
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  def explorer
    load_match_new
    @match_params = params[:match_exploration]
    @match_exploration = MatchExploration.new(@match_params)
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
    @volunteers = Volunteer.all.order(id: :desc)
    @volunteers = suitable_volunteers if @match_exploration.valid?
  end

  def index
    load_matches
  end

  def destroy
    load_match_from_params
    @match.destroy
    redirect_to matches_path
  end

  def update
    load_match_from_params
    if @match.update(match_params)
      redirect_to @match
    else
      render 'edit'
    end
  end

  private

  def load_match_new
    @match = Match.new
  end
  def load_match_from_params
    @match = Match.find(params[:id])
  end

  def load_matches
    load_volunteer_and_client
    if @volunteer
      @matches = Match.where(volunteer_id: @volunteer.id).includes(:client, :volunteer)
    elsif @client
      @matches = Match.where(client_id: @client.id).includes(:client, :volunteer)
    else
      @matches = Match.all.order(id: :desc).includes(:client, :volunteer)
    end
  end

  def load_volunteer_and_client
    @volunteer = Volunteer.find(params[:volunteer_id]) if params[:volunteer_id]
    @client = Client.find(params[:client_id]) if params[:client_id]
  end

  def suitable_volunteers
    search_time_range = TimeRange.new(
      @match_exploration.day,
      @match_exploration.start_time,
      @match_exploration.end_time)
    Volunteer.all.select do |volunteer|
      volunteer.available?(search_time_range)
    end
  end

  def time_range_params?
    params[:day] && params[:start_time] && params[:end_time]
  end

  def match_params
    params.require(:match).permit(
      :client_id, :volunteer_id, :day, :start_time, :end_time, :from_match_explorer,
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
