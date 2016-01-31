class VolunteersController < ApplicationController
  include BreadcrumbGenerator

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
    @matches = @volunteer.matches
    load_availabilities
    load_specialties
    @volunteer_specialties_options = VolunteerSpecialty.all
    @load_map_js = true
    load_breadcrumbs(Volunteer, @volunteer)
  end

  def edit(_flash_message = nil)
    load_volunteer
    load_breadcrumbs(Volunteer, @volunteer, :edit)
  end

  def load_specialties
    @volunteer_specialties = @volunteer.volunteer_specialties.order(name: :asc)
  end

  def new
    @volunteer = Volunteer.new
    load_breadcrumbs(Volunteer, nil, :new)
  end

  def index
    @volunteers = Volunteer.all.order(last_name: :asc).includes(:matches)
    load_breadcrumbs(Volunteer)
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

  def add_volunteer_specialty
    load_volunteer
    service = VolunteerSpecialtyService.new(params)
    service.add_specialty_to_volunteer
    flash[:error] = service.flash_message
    redirect_to @volunteer
  end

  def remove_volunteer_specialty
    load_volunteer
    service = VolunteerSpecialtyService.new(params)
    service.remove_specialty_from_volunteer
    redirect_to @volunteer
  end

  def add_volunteer_availabilities
    service = VolunteerAvailabilityService.new(params)
    service.new_volunteer_availability(volunteer_availability_params)

    flash[:error] = service.volunteer_availability_errors
    load_volunteer
    load_availabilities

    @volunteer_specialties_options = VolunteerSpecialty.all
    redirect_to @volunteer
  end

  private

  def load_volunteer
    @volunteer = Volunteer.find(params[:id])
  end

  def load_availabilities
    service = VolunteerAvailabilityService.new(params)
    @volunteer_availability = service.volunteer_availability
    @volunteer_availabilities = service.volunteer_availabilities
  end

  def volunteer_specialty_params
    params.require(:volunteer).permit(:volunteer, :volunteer_specialty_ids)
  end

  def volunteer_specialty_removal_params
    params.permit(:volunteer_specialty_id)
  end

  def volunteer_availability_params
    params.require(:volunteer_availability).permit(:start_hour, :end_hour, :day)
  end

  def volunteer_params
    params.require(:volunteer).permit(:last_name, :first_name, :volunteer_specialty_ids, :address, :city, :province, :postal_code)
  end
end
