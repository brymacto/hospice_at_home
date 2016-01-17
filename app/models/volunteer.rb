class Volunteer < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  has_many :volunteer_availabilities, dependent: :destroy
  has_and_belongs_to_many :volunteer_specialties
  validates :first_name, presence: true
  validates :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    return if !has_address?
    "#{address}, #{city} #{province}, #{postal_code}"
  end

  def available?(match_time)
    matching_availabilities = load_matching_availabilities(match_time)

    matching_availabilities && matching_availabilities.size > 0
  end

  def load_matching_availabilities(match_time)
    volunteer_availabilities.select do |availability|
      availability_matching?(availability, match_time)
    end
  end

  def any_address_changed?
    address_changed? || city_changed? || province_changed? || postal_code_changed?
  end

  private

  # TODO: Move above logic into availability model.
  def availability_matching?(availability, match_time)
    day_matching = (availability.day == match_time.day)
    start_time_matching = (availability.start_hour <= match_time.start_time)
    end_time_matching = (availability.end_hour >= match_time.end_time)

    day_matching && start_time_matching && end_time_matching
  end

  def has_address?
    address != nil && address.size > 0
  end
end
