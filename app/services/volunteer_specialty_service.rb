class VolunteerSpecialtyService
  attr_reader :volunteer, :volunteer_specialty, :flash_message

  def initialize(params)
    @params = params
    @volunteer = Volunteer.find(@params[:id])
    @volunteer_specialty = VolunteerSpecialty.find(@params[:volunteer][:volunteer_specialty_ids])
    @flash_message = nil
  end

  def add_specialty_to_volunteer
    if volunteer_includes_specialty
      @flash_message = "#{@volunteer.name} already has the specialty #{@volunteer_specialty.name}"
      false
    else
      @volunteer.volunteer_specialties << @volunteer_specialty
      true
    end
  end

  def remove_specialty_from_volunteer
    @volunteer.volunteer_specialties.delete(@volunteer_specialty)
  end

  private

  def volunteer_includes_specialty
    @volunteer.volunteer_specialties.include?(@volunteer_specialty)
  end
end
