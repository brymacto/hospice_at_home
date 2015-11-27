class VolunteerAvailability < ActiveRecord::Base
  belongs_to :volunteer

  validates :start_hour, presence: true
  validates :end_hour, presence: true
  validates :day, presence: true
  validates :start_hour, numericality: { only_integer: true }
  validates :end_hour, numericality: { only_integer: true }
  validate :start_hour_possible_times

  private

  def start_hour_possible_times
    if (start_hour < 0) || (start_hour > 23)
      errors.add(:start_hour, "must be between 0 and 23 (12:00 AM and 11:00 PM)")
    end

  end
  def discount_cannot_be_greater_than_total_value
    if discount > total_value
      errors.add(:discount, "can't be greater than total value")
    end
  end
end