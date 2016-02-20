class AvailabilityMergingService
  def initialize(volunteer)
    @volunteer = volunteer
    @availabilities = @volunteer.availabilities
    @availabilities_already_merged = []
    @flash_message_contents = []
  end

  def merge
    merge_duplicate_availabilities
    refresh_availabilities
    merge_bordering_availabilities
    refresh_availabilities
    merge_overlapping_availabilities
  end

  def flash_message
    return if @flash_message_contents.empty?
    "The following availabilities have been merged: #{@flash_message_contents.join('; ')}"
  end

  private

  def update_flash_messages(availability_1, availability_2)
    @flash_message_contents << "#{availability_1.description} and #{availability_2.description(time_only: true)}"
  end

  def merge_duplicate_availabilities
    @availabilities.each do |availability|
      return if already_merged?(availability)

      duplicate_availabilities = get_duplicate_availabilities(availability)

      duplicate_availabilities.each do |duplicate_availability|
        merge_availabilities(availability, duplicate_availability)
      end
    end
  end

  def merge_bordering_availabilities
    @availabilities.each do |availability|
      return if already_merged?(availability)

      bordering_availabilities = get_bordering_availabilities(availability)

      bordering_availabilities.each do |bordering_availability|
        merge_availabilities(availability, bordering_availability)
      end
    end
  end

  def merge_overlapping_availabilities
    @availabilities.each do |availability|
      return if already_merged?(availability)

      overlapping_availabilities = get_overlapping_availabilities(availability)

      overlapping_availabilities.each do |overlapping_availability|
        merge_availabilities(availability, overlapping_availability)
      end
    end
  end

  def merge_availabilities(availability_1, availability_2)
    return if availability_1 == availability_2

    create_merged_availability(availability_1, availability_2)

    mark_availabilities_as_merged(availability_1, availability_2)

    update_flash_messages(availability_1, availability_2)

    destroy_availabilities(availability_1, availability_2)
  end

  def mark_availabilities_as_merged(*availabilities)
    availabilities.each { |availability| @availabilities_already_merged << availability }
  end

  def get_duplicate_availabilities(availability)
    @availabilities.select do |availability_for_comparison|
      compare(availability, availability_for_comparison).availabilities_are_duplicates
    end
  end

  def get_bordering_availabilities(availability)
    @availabilities.select do |availability_for_comparison|
      compare(availability, availability_for_comparison).availabilities_are_bordering
    end
  end

  def get_overlapping_availabilities(availability)
    @availabilities.select do |availability_for_comparison|
      compare(availability, availability_for_comparison).availabilities_are_overlapping
    end
  end

  def already_merged?(availability)
    @availabilities_already_merged.include?(availability)
  end

  def create_merged_availability(availability_1, availability_2)
    Availability.create!(day: availability_1.day, start_time: [availability_1.start_time, availability_2.start_time].min, end_time: [availability_1.end_time, availability_2.end_time].max, volunteer: @volunteer)
  end

  def destroy_availabilities(*availabilities)
    availabilities.each(&:destroy)
  end

  def refresh_availabilities
    @availabilities = @volunteer.reload.availabilities
    @availabilities_already_merged = []
  end

  def compare(availability_1, availability_2)
    AvailabilityComparisonService.new(availability_1, availability_2)
  end
end
