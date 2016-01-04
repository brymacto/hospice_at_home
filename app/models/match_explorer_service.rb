class MatchExplorerService
  attr_reader :match_exploration, :volunteers

  def initialize(params)
    @params = params
    @match_exploration = MatchExploration.new(match_exploration_params)
    @volunteers = load_volunteers(@match_exploration.valid?)
  end

  def day_options
    Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  private

  def match_exploration_params
    if @params == nil
      {}
    else
    @params.permit(
      :client_id,
      :volunteer_id,
      :day,
      :start_time,
      :end_time
    )
    end
  end

  def load_volunteers(match_exploration_valid)
    return unless match_exploration_valid

    @volunteers = Volunteer.joins(:volunteer_availabilities).where(
      "volunteer_availabilities.start_hour <= :start_time AND
      volunteer_availabilities.end_hour >= :end_time AND
      volunteer_availabilities.day = :day",
      start_time: match_exploration_time_range.start_time,
      end_time: match_exploration_time_range.end_time,
      day: match_exploration_time_range.day).distinct.order(:last_name)
  end

  def match_exploration_time_range
    TimeRange.new(
      @match_exploration.day,
      @match_exploration.start_time,
      @match_exploration.end_time)
  end
end