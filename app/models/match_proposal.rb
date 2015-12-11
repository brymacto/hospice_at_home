class MatchProposal < ActiveRecord::Base
  has_many :match_requests
  has_many :volunteers, through: :match_requests
  has_one :client

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :day, presence: true
  validates :start_time, numericality: { only_integer: true }
  validates :end_time, numericality: { only_integer: true }
  validate :start_time_possible_times
  validate :start_time_before_end_time

  composed_of :availability_time, class_name: 'TimeRange', mapping: [
    %w(day day), %w(start_time start_time), %w(end_time end_time)
  ]

  private

  def start_time_possible_times
    return unless (start_time < 0) || (start_time > 23)
    errors.add(:start_time, 'must be between 0 and 23 (12:00 AM and 11:00 PM)')
  end

  def start_time_before_end_time
    errors.add(:start_time, 'must be before end time') if start_time >= end_time
  end
end
