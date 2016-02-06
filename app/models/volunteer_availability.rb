class VolunteerAvailability < ActiveRecord::Base
  belongs_to :volunteer

  validates :start_hour, presence: true
  validates :end_hour, presence: true
  validates :day, presence: true
  validates :start_hour, numericality: { only_integer: true }
  validates :end_hour, numericality: { only_integer: true }
  validate :start_hour_possible_times
  validate :start_hour_before_end_hour

  composed_of :availability_time, class_name: 'TimeRange', mapping: [
    %w(day day), %w(start_hour start_time), %w(end_hour end_time)
  ]

  def description(time_only = false)
    return "from #{availability_time.start_time} to #{availability_time.end_time}" if time_only
    "#{availability_time.day.capitalize}, from #{availability_time.start_time} to #{availability_time.end_time}"
  end

  private

  def start_hour_possible_times
    return unless (start_hour < 0) || (start_hour > 23)
    errors.add(:start_hour, 'must be between 0 and 23 (12:00 AM and 11:00 PM)')
  end

  def start_hour_before_end_hour
    errors.add(:start_hour, 'must be before end hour') if start_hour >= end_hour
  end
end
