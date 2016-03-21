class AvailabilityComparisonService
  def initialize(availability_1, availability_2)
    @availability_1 = availability_1
    @availability_2 = availability_2
  end

  def availabilities_are_duplicates
    return false if availabilities_are_same_object
    @availability_1.time_range == @availability_2.time_range
  end

  def availabilities_are_bordering
    return false if availabilities_are_same_object
    @availability_1.time_range.borders(@availability_2.time_range)
  end

  def availabilities_are_overlapping
    return false if availabilities_are_same_object
    @availability_1.time_range.overlaps_or_is_overlapped_by(@availability_2.time_range)
  end

  private

  def availabilities_are_same_object
    @availability_1 == @availability_2
  end
end
