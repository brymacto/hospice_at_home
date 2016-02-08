class AvailabilitiesController < ApplicationController
  def destroy
    load_availability
    @availability.destroy
    redirect_to volunteer_path(@volunteer)
  end

  def edit
    load_availability
  end

  def update
    load_availability
    @availability.update(availability_params)
    redirect_to edit_volunteer_path(@volunteer)
  end

  private

  def load_availability
    @availability = Availability.find(params[:id])
    @volunteer = @availability.volunteer
  end

  def availability_params
    params.require(:availability).permit(:volunteer, :day, :start_time, :end_time)
  end
end
