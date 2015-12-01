class VolunteersController < ApplicationController
  def create
    @volunteer = Volunteer.new(volunteer_params)
    if @volunteer.save
      redirect_to @volunteer
    else
      flash[:error] = @volunteer.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def show
    load_volunteer
    @matches = @volunteer.matches
    @volunteer_availabilities = @volunteer.volunteer_availabilities
  end

  def edit(_flash_message = nil)
    load_volunteer
    load_availabilities
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
      flash[:error] = @volunteer.errors.full_messages.to_sentence
      load_availabilities
      render 'edit'
    end
  end

  def load_availabilities
    @volunteer_availability = VolunteerAvailability.new
    @volunteer_availabilities = @volunteer.volunteer_availabilities
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  def add_volunteer_availabilities
    attrs = params.require(:volunteer_availability).permit(:start_hour, :end_hour, :day)
    @volunteer_availability = VolunteerAvailability.new(attrs.merge(volunteer_id: params[:id]))
    unless @volunteer_availability.save
      flash[:error] = @volunteer_availability.errors.full_messages.to_sentence
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
