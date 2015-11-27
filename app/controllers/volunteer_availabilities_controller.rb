class VolunteerAvailabilitiesController < ApplicationController
  def destroy
    p "Clicked destroy"
    @volunteer_availability = VolunteerAvailability.find(params[:id])
    @volunteer = @volunteer_availability.volunteer
    @volunteer_availability.destroy
    # render nothing: true
    redirect_to volunteer_path(@volunteer)
  end

  private

  def volunteer_availability_params
    params.require(:volunteer_availability).permit(:volunteer)
  end
end