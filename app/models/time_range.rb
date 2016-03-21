class TimeRange
  attr_reader :day, :start_time, :end_time

  def initialize(day, start_time, end_time)
    @day = day
    @start_time = start_time.to_i
    @end_time = end_time.to_i
  end

  def ==(other)
    day == other.day && start_time == other.start_time && end_time == other.end_time
  end

  def contains(other_time_range)
    day == other_time_range.day && start_time <= other_time_range.start_time && end_time >= other_time_range.end_time
  end

  def has_same_day(other_time_range)
    day == other_time_range.day
  end

  def borders(other_time_range)
    has_same_day(other_time_range) &&
      (start_time == other_time_range.end_time ||
        end_time == other_time_range.start_time)
  end

  def overlaps(other_time_range)
    has_same_day(other_time_range) && (partially_overlaps(other_time_range) || fully_overlaps(other_time_range))
  end

  def overlaps_or_is_overlapped_by(other_time_range)
    overlaps(other_time_range) || other_time_range.overlaps(self)
  end

  private

  def partially_overlaps(other_time_range)
    ((@start_time <= other_time_range.start_time &&
      @end_time >= other_time_range.start_time &&
      @end_time <= other_time_range.end_time))
  end

  def fully_overlaps(other_time_range)
    (@start_time >= other_time_range.start_time && @end_time <= other_time_range.end_time)
  end
end
