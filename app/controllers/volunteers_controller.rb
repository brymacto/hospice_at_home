class VolunteersController < ApplicationController
  def create
    @volunteer = Volunteer.new(volunteer_params)
    if @volunteer.save
      redirect_to @volunteer
    else
      flash.now[:error] = @volunteer.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def show
    load_volunteer
    @breadcrumb_links = [{path: volunteers_path, name: 'Volunteers'}, {path: volunteer_path(@volunteer), name: @volunteer.name}]
    @matches = @volunteer.matches
    @volunteer_availabilities = @volunteer.volunteer_availabilities
    load_specialties
  end

  def edit(_flash_message = nil)
    load_volunteer
    @breadcrumb_links = [{path: volunteers_path, name: 'Volunteers'}, {path: volunteer_path(@volunteer), name: @volunteer.name}, {path: edit_volunteer_path, name: 'Edit'}]
    load_availabilities
    load_specialties
    @volunteer_specialty = VolunteerSpecialty.new
    @volunteer_specialties_options = VolunteerSpecialty.all
  end

  def load_specialties
    @volunteer_specialties = @volunteer.volunteer_specialties.order(name: :asc)
  end

  def new
    @breadcrumb_links = [{path: volunteers_path, name: 'Volunteers'}, {path: new_volunteer_path, name: 'Add volunteer'}]
    @volunteer = Volunteer.new
  end

  def index
    @breadcrumb_links = [{path: volunteers_path, name: 'Volunteers'}]
    @volunteers = Volunteer.all.order(last_name: :asc)
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
      flash.now[:error] = @volunteer.errors.full_messages.to_sentence
      load_availabilities
      redirect_to 'edit'
    end
  end

  def load_availabilities
    @volunteer_availability = VolunteerAvailability.new
    @volunteer_availabilities = @volunteer.volunteer_availabilities
    @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  def add_volunteer_specialty
    load_volunteer
    volunteer_specialty = VolunteerSpecialty.find(volunteer_specialty_params[:volunteer_specialty_ids][0])
    if @volunteer.volunteer_specialties.include?(volunteer_specialty)
      flash[:error] = "#{@volunteer.name} already has the specialty #{volunteer_specialty.name}"
    else
      @volunteer.volunteer_specialties << volunteer_specialty unless @volunteer.volunteer_specialties.include?(volunteer_specialty)
    end
    redirect_to @volunteer
  end

  def add_volunteer_availabilities
    attrs = volunteer_availability_params
    @volunteer_availability = VolunteerAvailability.new(attrs.merge(volunteer_id: params[:id]))
    unless @volunteer_availability.save
      flash.now[:error] = @volunteer_availability.errors.full_messages.to_sentence
    end
    load_volunteer
    load_availabilities
    @volunteer_specialties_options = VolunteerSpecialty.all
    render 'edit'
  end

  private

  def load_volunteer
    @volunteer = Volunteer.find(params[:id])
  end

  def volunteer_specialty_params
    params.require(:volunteer).permit(:volunteer_specialty_ids)
  end

  def volunteer_availability_params
    params.require(:volunteer_availability).permit(:start_hour, :end_hour, :day)
  end

  def volunteer_params
    params.require(:volunteer).permit(:last_name, :first_name, :volunteer_specialty_ids)
  end
end
