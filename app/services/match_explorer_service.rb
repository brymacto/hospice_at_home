class MatchExplorerService
  attr_reader :match_exploration, :volunteers

  def initialize(params)
    @params = params
    @match_exploration = MatchExploration.new(match_exploration_params)
    @match_exploration.specialty_id = nil if @match_exploration.specialty_id == ''
    @volunteers = load_volunteers(@match_exploration.valid?)
  end

  def day_options
    Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
  end

  private

  def match_exploration_params
    if @params.nil?
      {}
    else
      @params.permit(
        :client_id,
        :volunteer_id,
        :day,
        :start_time,
        :end_time,
        :specialty_id
      )
    end
  end

  def load_volunteers(match_exploration_valid)
    return unless match_exploration_valid
    @volunteers = Volunteer.joins('LEFT OUTER JOIN volunteer_availabilities ON
                                  volunteer_availabilities.volunteer_id = volunteers.id
                                  LEFT OUTER JOIN volunteer_specialties_volunteers ON
                                  volunteer_specialties_volunteers.volunteer_id = volunteers.id').where(
                                    match_exploration_query,
                                    start_time: match_exploration_time_range.start_time,
                                    end_time: match_exploration_time_range.end_time,
                                    day: match_exploration_time_range.day,
                                    volunteer_specialty_id: match_exploration.specialty_id).distinct.order(:last_name)
  end

  def match_exploration_query
    "volunteer_availabilities.start_hour <= :start_time AND
     volunteer_availabilities.end_hour >= :end_time AND
     volunteer_availabilities.day = :day#{' AND volunteer_specialties_volunteers.volunteer_specialty_id = :volunteer_specialty_id' if match_exploration.specialty_id}"
  end

  def match_exploration_time_range
    TimeRange.new(
      @match_exploration.day,
      @match_exploration.start_time,
      @match_exploration.end_time)
  end
end