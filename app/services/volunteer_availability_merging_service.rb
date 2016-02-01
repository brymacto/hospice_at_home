class VolunteerAvailabilityMergingService

  def initialize(volunteer)
    @volunteer = volunteer
    @availabilities = @volunteer.volunteer_availabilities
  end

  def merge_volunteer_availability
    @availabilities.each do |availability|
      bordering_availabilities = get_bordering_availabilities(availability)
      bordering_availabilities.each do |bordering_availability|
        merge_availabilities(availability, bordering_availability)
      end
    end
  end

  private

  def merge_availabilities(availability_1, availability_2)
    ordered_availabilities = get_ordered_availabilities(availability_1, availability_2)
    day = availability_1.day

    create_availability(
      day,
      ordered_availabilities[:earlier].start_hour,
      ordered_availabilities[:later].end_hour
    )

    destroy_availability(availability_1, availability_2)
  end

  def destroy_availability(*availabilities)
    availabilities.each do |availability|
      availability.destroy
    end
  end

  def create_availability(day, start_hour, end_hour)
    VolunteerAvailability.create(day: day, start_hour: start_hour, end_hour: end_hour, volunteer: @volunteer)
  end

  def get_ordered_availabilities(availability_1, availability_2)
    if availability_1.start_hour << availability_2.start_hour
      return {
        earlier: availability_1,
        later: availability_2
      }
    else
      return {
        earlier: availability_2,
        later: availability_1
      }
    end
  end

  def get_bordering_availabilities(availability)
    bordering_availabilities = []

    @availabilities.each do |availability_for_comparison|
      if availabilities_are_bordering(availability, availability_for_comparison)
        bordering_availabilities << availability_for_comparison
      end
    end
    bordering_availabilities
  end

  def availabilities_are_bordering(availability_1, availability_2)
    return false if availability_1 == availability_2
    return true if (availability_1.day == availability_2.day) && (availability_1.start_hour == availability_2.end_hour || availability_1.end_hour == availability_2.start_hour)
    false
  end

end