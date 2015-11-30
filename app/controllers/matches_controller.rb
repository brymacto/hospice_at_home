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

  def match_params
    params.require(:match).permit(:client_id, :volunteer_id, :day, :start_time, :end_time)
  end
end
