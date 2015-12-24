class MatchProposal < ActiveRecord::Base
  has_many :match_requests, dependent: :destroy
  has_many :volunteers, through: :match_requests
  belongs_to :client
  validates :match_requests, presence: { message: "are sent to volunteers you select.  You must select volunteers to create a match proposal." }

  accepts_nested_attributes_for :match_requests

  composed_of :availability_time, class_name: 'TimeRange', mapping: [
    %w(day day), %w(start_time start_time), %w(end_time end_time)
  ]

  DAYS_OF_THE_WEEK = %w(monday tuesday wednesday thursday friday saturday sunday)

  validates :day, presence: true
  validates :start_time, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 24 }
  validates :end_time, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 24 }
  validates_numericality_of :end_time,
    message: 'must be after start time',
    greater_than: ->(mp) { mp.start_time },
    if: ->(mp) { mp.start_time.present? }
  validate :day_is_real_day

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

  def day_is_real_day
    errors.add(:day, 'must be a day of the week') if !DAYS_OF_THE_WEEK.include?(day)
  end
end