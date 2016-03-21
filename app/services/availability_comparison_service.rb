class AvailabilityComparisonService
  def initialize(availability_1, availability_2)
    @availability_1 = availability_1
    @availability_2 = availability_2
  end

  def availabilities_are_duplicates
    return false if availabilities_are_same_object
    @availability_1.availability_time == @availability_2.availability_time
  end

  def availabilities_are_bordering
    return false if availabilities_are_same_object
    @availability_1.availability_time.borders(@availability_2.availability_time)
  end

  def availabilities_are_overlapping
    return false if availabilities_are_same_object
    @availability_1.availability_time.overlaps_or_is_overlapped_by(@availability_2.availability_time)
  end

  private

  def availabilities_are_same_object
    @availability_1 == @availability_2
  end
end
