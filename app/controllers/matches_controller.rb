class MatchesController < ApplicationController
  def create
    @match = Match.new(match_params)
    if @match.save
      redirect_to @match
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
  end

  def index
    @matches = Match.all.order(id: :desc)
    # @matches = [OpenStruct.new(client_name: 'John Doe', volunteer_name: 'Jane Doex', id: 1), OpenStruct.new(client_name: 'Johnny Doe', volunteer_name: 'Jane Doex', id: 2)]
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
    params.require(:match).permit(:client_id, :volunteer_id)
  end
end
