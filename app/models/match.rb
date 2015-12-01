class Match < ActiveRecord::Base
  belongs_to :client
  belongs_to :volunteer

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :day, presence: true
  validates :start_time, numericality: { only_integer: true }
  validates :end_time, numericality: { only_integer: true }
  validate :start_time_possible_times
  validate :start_time_before_end_time

  composed_of :match_time, class_name: 'TimeRange', mapping: [['day', 'day'], ['start_time', 'start_time'], ['end_time', 'end_time']]

  def client_name
    Client.find(client_id).name
  end

  def volunteer_name
    Volunteer.find(volunteer_id).name
  end

  def day_and_time
    "#{day.capitalize}, #{start_time} to #{end_time}"
  end

  private

  def start_time_possible_times
    return unless (start_time.to_i < 0) || (start_time.to_i > 23)
    errors.add(:start_time, 'must be between 0 and 23 (12:00 AM and 11:00 PM)')
  end

  def start_time_before_end_time
    return unless start_time.to_i >= end_time.to_i
    errors.add(:start_time, 'must be before end hour')
  end
end
