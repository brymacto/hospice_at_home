class AvailabilityService
  attr_reader :volunteer, :availability, :availabilities, :merging_result

  def initialize(params)
    @params = params
    @volunteer = Volunteer.find(params[:id])
    @availability = Availability.new
    @availabilities = @volunteer.availabilities.sort_by { |availability| [DAY_NUMBERS.fetch(availability.day.to_sym, 9), availability.start_hour] }
    @merging_result = nil
  end

  def new_availability(attrs)
    attrs.merge!(volunteer_id: @volunteer.id)
    @availability = Availability.new(attrs)
    save_success = @availability.save
    @merging_result = @volunteer.merge_volunteer_availabilities if save_success
    save_success
  end

  def availability_errors
    @availability.errors.full_messages.to_sentence
  end
end
