class Match < ActiveRecord::Base
  belongs_to :client
  belongs_to :volunteer

  DAYS_OF_THE_WEEK = %w(monday tuesday wednesday thursday friday saturday sunday)

  validates :client_id, presence: true
  validates :volunteer_id, presence: true
  validates :start_time, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 24 }
  validates :end_time, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 24 }
  validates_numericality_of :end_time,
                            message: 'must be after start time',
                            greater_than: ->(mp) { mp.start_time },
                            if: ->(mp) { mp.start_time.present? }
  validate :day_is_real_day

  delegate :name, to: :client, prefix: true
  delegate :name, to: :volunteer, prefix: true

  composed_of :match_time, class_name: 'TimeRange', mapping: [
    %w(day day), %w(start_time start_time), %w(end_time end_time)
  ]

  def day_and_time
    "#{day.capitalize}, #{start_time} to #{end_time}"
  end

  private

  def day_is_real_day
    errors.add(:day, 'must be a day of the week') if !DAYS_OF_THE_WEEK.include?(day)
  end
end
