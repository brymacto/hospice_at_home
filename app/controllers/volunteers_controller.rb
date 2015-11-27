class VolunteersController < ApplicationController
  def create
    @volunteer = Volunteer.new(volunteer_params)
    if @volunteer.save
      redirect_to @volunteer
    end
  end

  def show
    load_volunteer
  end

  def edit(flash_message = nil)
    load_volunteer
    @volunteer_availability = VolunteerAvailability.new 
    @volunteer_availabilities = @volunteer.volunteer_availabilities
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
    load_volunteer
    @volunteer.destroy
    redirect_to volunteers_path
  end

  def update
    load_volunteer
    if @volunteer.update(volunteer_params)
      redirect_to @volunteer
    else
      render 'edit'
    end
  end

  def add_volunteer_availabilities
    attrs = params.require(:volunteer_availability).permit(:start_hour, :end_hour, :day)
    @volunteer_availability = VolunteerAvailability.new(attrs.merge(volunteer_id: params[:id]))
    if !@volunteer_availability.save
      flash[:error] = ""
      flash[:error] << 'You must include day. ' if @volunteer_availability.day == nil
      flash[:error] << 'Start hour must be an integer. ' if !@volunteer_availability.start_hour.is_a?(Integer)
      flash[:error] << 'End hour must be an integer. ' if !@volunteer_availability.end_hour.is_a?(Integer)
    end
    edit
  end

  private

  def load_volunteer
    @volunteer = Volunteer.find(params[:id])
  end

  def volunteer_params
    params.require(:volunteer).permit(:last_name, :first_name)
  end

end
