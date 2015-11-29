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

  attr_reader :day
  attr_reader :start_time
  attr_reader :end_time

  def client_name
    Client.find(client_id).name
  end

  def volunteer_name
    Volunteer.find(volunteer_id).name
  end

  private

  def start_time_possible_times
    if (start_time < 0) || (start_time > 23)
      errors.add(:start_time, "must be between 0 and 23 (12:00 AM and 11:00 PM)")
    end
  end
  def start_time_before_end_time
    if start_time >= end_time
      errors.add(:start_time, "must be before end hour")
    end
  end


end