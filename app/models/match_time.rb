class MatchTime
  attr_reader :day, :start_time, :end_time

  def initialize(day, start_time, end_time)
    @day = day
    @start_time = start_time
    @end_time = end_time
  end

  def ==(other)
    day == other.day && start_time == other.start_time && end_time == other.end_time
  end
end
