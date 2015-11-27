class VolunteerAvailability < ActiveRecord::Base
  belongs_to :volunteer

  validates :start_hour, presence: true
  validates :end_hour, presence: true
  validates :day, presence: true
end