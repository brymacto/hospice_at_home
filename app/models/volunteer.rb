class Volunteer < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  has_many :volunteer_availabilities, dependent: :destroy

  def name
    "#{first_name} #{last_name}"
  end

  def available?(day, start_time, end_time)
    availabilities = volunteer_availabilities
    matching_availabilities = volunteer_availabilities.select { |availability| (availability.day == day) && (availability.start_hour >= start_time) && (availability.end_hour <= end_time) }
    return true if matching_availabilities && matching_availabilities.size > 0
    false
    # availabilities_on_day = volunteer_availabilities.select { |availability| availability.day = day }
    # availabilities_on_day.each do |availability|
    #   return true if ((availability.start_hour >= start_time) && (availability.end_hour <= end_time)
    # end
  end
end
