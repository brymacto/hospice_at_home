class MatchesController < ApplicationController
  def create
    @match = Match.new(match_params)
    if @match.save
      redirect_to @match
    else
      flash[:error] = @match.errors.full_messages.to_sentence
      redirect_to new_match_path

    end
  end

  def show
    @match = Match.find(params[:id])
  end

  def edit
    @match = Match.find(params[:id])
  end

  def new
    @match = Match.new
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  def explorer
    @match_exploration = MatchExploration.new(params[:match_exploration])
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
    @volunteers = Volunteer.all.order(id: :desc)
    @volunteers = suitable_volunteers if @match_exploration.valid?
  end

  def index
    @matches = Match.all.order(id: :desc)
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy
    redirect_to matches_path
  end

  def update
    @match = Match.find(params[:id])
    if @match.update(match_params)
      redirect_to @match
    else
      render 'edit'
    end
  end

  private

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
      :client_id, :volunteer_id, :day, :start_time, :end_time,
      match_exploration_attributes: [:client_id,
                                     :volunteer_id,
                                     :day,
                                     :start_time,
                                     :end_time]
    )
  end
end
