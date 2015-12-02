class Volunteer < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  has_many :volunteer_availabilities, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def available?(match_time)
    matching_availabilities = volunteer_availabilities.select do |availability|
      availability_matching?(availability, match_time)
    end

    matching_availabilities && matching_availabilities.size > 0
  end

  # TODO: Move above logic into availability model.
  def availability_matching?(availability, match_time)
    ((availability.day == match_time.day) &&
    (availability.start_hour <= match_time.start_time) &&
    (availability.end_hour >= match_time.end_time))
  end
end
