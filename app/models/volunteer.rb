class Volunteer < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  has_many :availabilities, dependent: :destroy
  has_and_belongs_to_many :specialties

  validates :first_name, presence: true
  validates :last_name, presence: true

  geocoded_by :full_address
  after_validation :geocode,
                   if: ->(volunteer) { volunteer.any_address_changed? }

  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    return unless has_address?
    "#{address}, #{city} #{province}, #{postal_code}"
  end

  def available?(match_time)
    matching_availabilities = load_matching_availabilities(match_time)

    matching_availabilities && matching_availabilities.size > 0
  end

  def load_matching_availabilities(match_time)
    availabilities.select do |availability|
      availability_matching?(availability, match_time)
    end
  end

  def any_address_changed?
    address_changed? || city_changed? || province_changed? || postal_code_changed?
  end

  def has_been_geocoded?
    !latitude.nil? && !longitude.nil?
  end

  def merge_volunteer_availabilities
    service = AvailabilityMergingService.new(self)
    service.merge
    service.flash_message
  end

  private

  def availability_matching?(availability, match_time)
    availability.availability_time.contains(match_time)
  end

  def has_address?
    !address.nil? && address.size > 0
  end
end
