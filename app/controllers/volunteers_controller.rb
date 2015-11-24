class VolunteersController < ApplicationController
  def create
    @volunteer = Volunteer.new(volunteer_params)
    if @volunteer.save
      redirect_to @volunteer
    end
  end

  def show
    @volunteer = Volunteer.find(params[:id])
  end

  def edit
    @volunteer = Volunteer.find(params[:id])
    @volunteer_availability = VolunteerAvailability.new 
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
    render 'edit'
  end

  def new
    @volunteer = Volunteer.new
  end

  def index
    @volunteers = Volunteer.all.order(id: :desc)
  end

  def destroy
    @volunteer = Volunteer.find(params[:id])
    @volunteer.destroy
    redirect_to volunteers_path
  end

  def update
    @volunteer = Volunteer.find(params[:id])
    if @volunteer.update(volunteer_params)
      redirect_to @volunteer
    else
      render 'edit'
    end
  end

  def add_volunteer_availabilities
    attrs = params.require(:volunteer_availability).permit(:start_hour, :end_hour, :day)
    @volunteer_availability = VolunteerAvailability.new(attrs.merge(volunteer_id: params[:id]))
    @volunteer_availability.save
    edit
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:last_name, :first_name)
  end

end
