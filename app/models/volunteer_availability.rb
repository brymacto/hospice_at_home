class VolunteerAvailability < ActiveRecord::Base
  validates :start_hour, presence: true
  validates :end_hour, presence: true
  validates :day, presence: true
end