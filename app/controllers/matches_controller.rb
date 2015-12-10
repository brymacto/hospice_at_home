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
    load_match(new: false)
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
    load_volunteers(@match_exploration.valid?)
  end

  def index
    load_matches
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

  def load_volunteers(match_exploration_valid)
    return if !match_exploration_valid
    search_time_range = TimeRange.new(
      @match_exploration.day,
      @match_exploration.start_time,
      @match_exploration.end_time)
    @volunteers = Volunteer.all.select do |volunteer|
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
