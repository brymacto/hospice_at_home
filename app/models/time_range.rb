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
end
