class VolunteerAvailabilityService
  attr_reader :volunteer, :volunteer_availability, :volunteer_availabilities, :merging_result

  def initialize(params)
    @params = params
    @volunteer = Volunteer.find(params[:id])
    @volunteer_availability = VolunteerAvailability.new
    @volunteer_availabilities = @volunteer.volunteer_availabilities
    @merging_result = nil
  end

  def new_volunteer_availability(attrs)
    attrs.merge!(volunteer_id: @volunteer.id)
    @volunteer_availability = VolunteerAvailability.new(attrs)
    save_success = @volunteer_availability.save
    @merging_result = @volunteer.merge_volunteer_availabilities if save_success
    save_success
  end

  def volunteer_availability_errors
    @volunteer_availability.errors.full_messages.to_sentence
  end
end
