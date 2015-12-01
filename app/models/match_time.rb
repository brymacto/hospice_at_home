class MatchTime
  attr_reader :day, :start_time, :end_time

  def initialize(day, start_time, end_time)
    @day = day
    @start_time = start_time
    @end_time = end_time
  end

  def ==(other_match_time)
    day == other_match_time.day && start_time == other_match_time.start_time && end_time == other_match_time.end_time
  end
end
