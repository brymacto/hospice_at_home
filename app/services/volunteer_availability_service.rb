class VolunteerAvailabilityService
  attr_reader :volunteer, :volunteer_availability, :volunteer_availabilities

  def initialize(params)
    @params = params
    @volunteer = Volunteer.find(params[:id])
    @volunteer_availability = VolunteerAvailability.new
    @volunteer_availabilities = @volunteer.volunteer_availabilities
  end

  def new_volunteer_availability(attrs)
    attrs.merge!(volunteer_id: @volunteer.id)
    @volunteer_availability = VolunteerAvailability.new(attrs)
    save_success = @volunteer_availability.save
    @volunteer.merge_volunteer_availabilities if save_success
    save_success
  end

  def volunteer_availability_errors
    @volunteer_availability.errors.full_messages.to_sentence
  end
end
