class VolunteerAvailabilityMergingService

  def initialize(volunteer)
    @volunteer = volunteer
    @availabilities = @volunteer.volunteer_availabilities
    @availabilities_already_merged = []
  end

  def merge_volunteer_availability
    @availabilities.each do |availability|
      return if @availabilities_already_merged.include?(availability)
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
      ordered_availabilities[0].start_hour,
      ordered_availabilities[1].end_hour
    )

    mark_availabilities_as_merged(availability_1, availability_2)
    destroy_availabilities(availability_1, availability_2)
  end

  def mark_availabilities_as_merged(*availabilities)
    availabilities.each { |availability| @availabilities_already_merged << availability }
  end

  def destroy_availabilities(*availabilities)
    availabilities.each(&:destroy)
  end

  def create_availability(day, start_hour, end_hour)
    VolunteerAvailability.create!(day: day, start_hour: start_hour, end_hour: end_hour, volunteer: @volunteer)
  end

  def get_ordered_availabilities(availability_1, availability_2)
    [availability_1, availability_2].sort_by! do |availability|
      availability.start_hour
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