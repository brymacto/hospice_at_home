class MatchProposal < ActiveRecord::Base
  has_many :match_requests, dependent: :destroy
  has_many :volunteers, through: :match_requests
  belongs_to :client

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

  def day_and_time
    "#{day.capitalize}, #{start_time} to #{end_time}"
  end

  def check_status
    match_request_accepted = false
    match_requests.each do |match_request|
      match_request_accepted = true if match_request.status = 'accepted'
    end
    self.status = 'accepted' if match_request_accepted
    save
  end

  private

  def start_time_possible_times
    return unless (start_time < 0) || (start_time > 23)
    errors.add(:start_time, 'must be between 0 and 23 (12:00 AM and 11:00 PM)')
  end

  def start_time_before_end_time
    errors.add(:start_time, 'must be before end time') if start_time >= end_time
  end
end
