class VolunteerAvailabilityService
  attr_reader :volunteer, :volunteer_availability, :volunteer_availabilities

  def initialize(params)
    @params = params
    @volunteer = Volunteer.find(params[:id])
    @volunteer_availability = VolunteerAvailability.new
    @volunteer_availabilities = @volunteer.volunteer_availabilities
  end

  def new_volunteer_availability(attrs)
    return create_volunteer_availability(attrs)
  end

  def create_volunteer_availability(attrs)
    attrs.merge!(volunteer_id: @volunteer.id)
    @volunteer_availability = VolunteerAvailability.new(attrs)
    @volunteer_availability.save
  end

  def volunteer_availability_errors
    @volunteer_availability.errors.full_messages.to_sentence
  end
end