class AvailabilityComparisonService
  def initialize(availability_1, availability_2)
    @availability_1 = availability_1
    @availability_2 = availability_2
  end

  def availabilities_are_duplicates
    !availabilities_are_same_object &&
      availabilities_have_same_day &&
      @availability_1.start_hour == @availability_2.start_hour &&
      @availability_1.end_hour == @availability_2.end_hour &&
      @availability_1.volunteer == @availability_2.volunteer
  end

  def availabilities_are_bordering
    !availabilities_are_same_object &&
      (availabilities_have_same_day) &&
      (@availability_1.start_hour == @availability_2.end_hour ||
        @availability_1.end_hour == @availability_2.start_hour)
  end

  def availabilities_are_overlapping
    !availabilities_are_same_object &&
      availabilities_have_same_day &&
      (availabilities_are_fully_overlapping || availabilities_are_partially_overlapping)
  end

  private

  def availabilities_are_fully_overlapping
    overlaps_fully(@availability_1, @availability_2) ||
      overlaps_fully(@availability_2, @availability_1)
  end

  def availabilities_are_partially_overlapping
    overlaps_partially(@availability_1, @availability_2) ||
      overlaps_partially(@availability_2, @availability_1)
  end

  def overlaps_fully(availability_1, availability_2)
    (availability_1.start_hour >= availability_2.start_hour && availability_1.end_hour <= availability_2.end_hour)
  end

  def overlaps_partially(availability_1, availability_2)
    ((availability_1.start_hour <= availability_2.start_hour &&
      availability_1.end_hour >= availability_2.start_hour &&
      availability_1.end_hour <= availability_2.end_hour))
  end

  def availabilities_are_same_object
    @availability_1 == @availability_2
  end

  def availabilities_have_same_day
    @availability_1.day == @availability_2.day
  end
end
