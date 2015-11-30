class Volunteer < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  has_many :volunteer_availabilities, dependent: :destroy

  def name
    "#{first_name} #{last_name}"
  end

  def available?(day, start_time, end_time)
    matching_availabilities = volunteer_availabilities.select do |availability|
      availability_matching?(availability, day, end_time, start_time)
    end

    matching_availabilities && matching_availabilities.size > 0
  end

  # TODO: Move above logic into availability model.
  def availability_matching?(availability, day, end_time, start_time)
    (availability.day == day) && (availability.start_hour >= start_time) && (availability.end_hour <= end_time)
  end
end
