class VolunteerAvailabilityComparisonService
  def initialize(availability_1, availability_2)
    @availability_1 =availability_1
    @availability_2 = availability_2
  end

  def availabilities_are_duplicates
    @availability_1 != @availability_2 &&
      @availability_1.day == @availability_2.day &&
      @availability_1.start_hour == @availability_2.start_hour &&
      @availability_1.end_hour == @availability_2.end_hour &&
      @availability_1.volunteer == @availability_2.volunteer
  end

  def availabilities_are_bordering
    return false if @availability_1 == @availability_2
    return true if (@availability_1.day == @availability_2.day) &&
      (@availability_1.start_hour == @availability_2.end_hour ||
        @availability_1.end_hour == @availability_2.start_hour)
    false
  end


  def availabilities_are_overlapping
    return false if @availability_1 == @availability_2
    return true if (@availability_1.day == @availability_2.day) &&
      (
      (@availability_1.start_hour >= @availability_2.start_hour && @availability_1.end_hour <= @availability_2.end_hour) ||
        (@availability_1.end_hour >= @availability_2.start_hour && @availability_1.end_hour <= @availability_2.end_hour) ||
        (@availability_1.start_hour >= @availability_2.start_hour && @availability_1.start_hour <= @availability_2.end_hour)) ||
    (
      (@availability_2.start_hour >= @availability_1.start_hour && @availability_2.end_hour <= @availability_1.end_hour) ||
        (@availability_2.end_hour >= @availability_1.start_hour && @availability_2.end_hour <= @availability_1.end_hour) ||
        (@availability_2.start_hour >= @availability_1.start_hour && @availability_2.start_hour <= @availability_1.end_hour)
      )
    false
  end
end