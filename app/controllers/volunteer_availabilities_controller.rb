class VolunteerAvailabilitiesController < ApplicationController
  def destroy
    load_volunteer_availability
    @volunteer_availability.destroy
    # render nothing: true
    redirect_to edit_volunteer_path(@volunteer)
  end

  def edit
    load_volunteer_availability
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end


  def update
    load_volunteer_availability
    @volunteer_availability.update(volunteer_availability_params)
    redirect_to edit_volunteer_path(@volunteer)
  end

  private
  def load_volunteer_availability
    @volunteer_availability = VolunteerAvailability.find(params[:id])
    @volunteer = @volunteer_availability.volunteer
  end

  def volunteer_availability_params
    params.require(:volunteer_availability).permit(:volunteer, :day, :start_hour, :end_hour)
  end
end