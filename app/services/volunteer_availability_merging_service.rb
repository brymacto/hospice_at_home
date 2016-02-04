class VolunteerAvailabilityMergingService

  def initialize(volunteer)
    @volunteer = volunteer
    @availabilities = @volunteer.volunteer_availabilities
    @availabilities_already_merged = []
  end

  def merge
    merge_duplicate_availabilities
    refresh_availabilities
    merge_bordering_availabilities
    refresh_availabilities
    merge_overlapping_availabilities
  end

  private

  def merge_duplicate_availabilities
    @availabilities.each do |availability|
      return if @availabilities_already_merged.include?(availability)

      duplicate_availabilities = get_duplicate_availabilities(availability)

      duplicate_availabilities.each do |duplicate_availability|
        merge_availabilities(availability, duplicate_availability)
      end
    end
  end

  def merge_bordering_availabilities
    @availabilities.each do |availability|
      return if @availabilities_already_merged.include?(availability)

      bordering_availabilities = get_bordering_availabilities(availability)

      bordering_availabilities.each do |bordering_availability|
        merge_availabilities(availability, bordering_availability)
      end
    end
  end

  def merge_overlapping_availabilities
    @availabilities.each do |availability|
      return if @availabilities_already_merged.include?(availability)

      overlapping_availabilities = get_overlapping_availabilities(availability)

      overlapping_availabilities.each do |overlapping_availability|
        merge_availabilities(availability, overlapping_availability)
      end
    end
  end

  def refresh_availabilities
    @availabilities = @volunteer.reload.volunteer_availabilities
    @availabilities_already_merged = []
  end

  def merge_availabilities(availability_1, availability_2)
    return if availability_1 == availability_2

    create_merged_availability(availability_1, availability_2)

    mark_availabilities_as_merged(availability_1, availability_2)

    destroy_availabilities(availability_1, availability_2)
  end

  def mark_availabilities_as_merged(*availabilities)
    availabilities.each { |availability| @availabilities_already_merged << availability }
  end

  def get_duplicate_availabilities(availability)
    @availabilities.select do |availability_for_comparison|
      availabilities_are_duplicates(availability, availability_for_comparison)
    end
  end

  def availabilities_are_duplicates(availability_1, availability_2)
    availability_1 != availability_2 &&
      availability_1.day == availability_2.day &&
      availability_1.start_hour == availability_2.start_hour &&
      availability_1.end_hour == availability_2.end_hour &&
      availability_1.volunteer == availability_2.volunteer
  end


  def get_bordering_availabilities(availability)
    @availabilities.select do |availability_for_comparison|
      availabilities_are_bordering(availability, availability_for_comparison)
    end
  end

  def availabilities_are_bordering(availability_1, availability_2)
    return false if availability_1 == availability_2
    return true if (availability_1.day == availability_2.day) &&
      (availability_1.start_hour == availability_2.end_hour ||
        availability_1.end_hour == availability_2.start_hour)
    false
  end

  def get_overlapping_availabilities(availability)
    @availabilities.select do |availability_for_comparison|
      availabilities_are_overlapping(availability, availability_for_comparison)
    end
  end

  def availabilities_are_overlapping(availability_1, availability_2)
    return false if availability_1 == availability_2
    return true if (availability_1.day == availability_2.day) &&
      (
      (availability_1.start_hour >= availability_2.start_hour && availability_1.end_hour <= availability_2.end_hour) ||
        (availability_1.end_hour >= availability_2.start_hour && availability_1.end_hour <= availability_2.end_hour) ||
        (availability_1.start_hour >= availability_2.start_hour && availability_1.start_hour <= availability_2.end_hour)
      )
    false
  end

  def destroy_availabilities(*availabilities)
    availabilities.each(&:destroy)
  end

  def create_merged_availability(availability_1, availability_2)
    VolunteerAvailability.create!(day: availability_1.day, start_hour: [availability_1.start_hour, availability_2.start_hour].min, end_hour: [availability_1.end_hour, availability_2.end_hour].max, volunteer: @volunteer)
  end
end