class SpecialtyService
  attr_reader :volunteer, :specialty, :flash_message

  def initialize(params)
    @params = params
    @volunteer = Volunteer.find(@params[:id])
    @specialty = Specialty.find(@params[:volunteer][:specialty_ids])
    @flash_message = nil
  end

  def add_specialty_to_volunteer
    if volunteer_includes_specialty
      @flash_message = "#{@volunteer.name} already has the specialty #{@specialty.name}"
      false
    else
      @volunteer.specialties << @specialty
      true
    end
  end

  def remove_specialty_from_volunteer
    @volunteer.specialties.delete(@specialty)
  end

  private

  def volunteer_includes_specialty
    @volunteer.specialties.include?(@specialty)
  end
end
