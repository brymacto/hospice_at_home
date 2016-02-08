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
    load_assigns(:volunteer, :availabilities, :volunteer_specialties)
    @matches = @volunteer.matches
    @volunteer_specialties_options = VolunteerSpecialty.all
    @load_map_js = true
    load_breadcrumbs(Volunteer, @volunteer)
  end

  def edit(_flash_message = nil)
    load_volunteer
    load_breadcrumbs(Volunteer, @volunteer, :edit)
  end

  def new
    @volunteer = Volunteer.new
    load_breadcrumbs(Volunteer, nil, :new)
  end

  def index
    load_volunteers
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

    service = VolunteerSpecialtyService.new(volunteer_specialty_params)
    service.add_specialty_to_volunteer

    flash[:error] = service.flash_message
    redirect_to @volunteer
  end

  def remove_volunteer_specialty
    load_volunteer
    service = VolunteerSpecialtyService.new(volunteer_specialty_params)
    service.remove_specialty_from_volunteer

    redirect_to @volunteer
  end

  def add_volunteer_availabilities
    service = VolunteerAvailabilityService.new(availability_service_params)
    service.new_availability(availability_params)

    flash[:error] = service.availability_errors
    flash[:notice] = service.merging_result
    load_assigns(:volunteer, :availabities)
    load_availabilities

    @volunteer_specialties_options = VolunteerSpecialty.all
    redirect_to @volunteer
  end

  private

  def load_assigns(*assigns)
    assigns.map!(&:to_sym)

    load_volunteer if assigns.include?(:volunteer)
    load_volunteers if assigns.include?(:volunteers)
    load_availabilities if assigns.include?(:availabilities)
    load_volunteer_specialties if assigns.include?(:volunteer_specialties)
  end

  def load_volunteer
    @volunteer = Volunteer.find(params[:id])
  end

  def load_volunteers
    @volunteers = Volunteer.all.order(last_name: :asc).includes(:matches)
  end

  def load_availabilities
    service = VolunteerAvailabilityService.new(availability_service_params)
    @availability = service.availability
    @availabilities = service.availabilities
  end

  def load_volunteer_specialties
    @volunteer_specialties = @volunteer.volunteer_specialties.order(name: :asc)
  end

  def availability_params
    params.require(:availability).permit(:start_hour, :end_hour, :day)
  end

  def availability_service_params
    params.permit(:id)
  end

  def volunteer_params
    params.require(:volunteer).permit(:last_name, :first_name, :volunteer_specialty_ids, :address, :city, :province, :postal_code)
  end

  def volunteer_specialty_params
    params.permit(:id, volunteer: [:volunteer_specialty_ids])
  end
end
