class MatchesController < ApplicationController
  def create
    @match = Match.new(match_params)
    if @match.save
      redirect_to @match
    else
      flash[:error] = @match.errors.full_messages.to_sentence
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
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
    @volunteers = Volunteer.all.order(id: :desc)
    if has_time_range_params
      @volunteers = suitable_volunteers
    end
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
    Volunteer.find_each do |volunteer|
      volunteer.available?(TimeRange.new(params[:day], params[:start_time].to_i, params[:end_time].to_i))
    end
  end

  def has_time_range_params
    params[:day] && params[:start_time] && params[:end_time]
  end

  def match_params
    params.require(:match).permit(:client_id, :volunteer_id, :day, :start_time, :end_time)
  end
end
