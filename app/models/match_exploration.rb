class MatchExploration
  include ActiveModel::Model
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :day, presence: true
  validates :start_time, numericality: { only_integer: true }
  validates :end_time, numericality: { only_integer: true }
  validate :start_time_possible_times
  validate :end_time_possible_times
  validate :start_time_before_end_time

  attr_accessor :day, :start_time, :end_time

  # TODO: Investigate whether composed_of can be used without ActiveRecord
  # composed_of :match_exploration_time_range, class_name: 'TimeRange', mapping: [
  #     %w(day day), %w(start_time start_time), %w(end_time end_time)
  # ]

  def values_nil?
    (start_time.nil?) && (end_time.nil?) && (day.nil?)
  end

  private

  def start_time_possible_times
    return unless (start_time.to_i < 0) || (start_time.to_i > 23)
    errors.add(:start_time, 'must be between 0 and 23 (12:00 AM and 11:00 PM)')
  end

  def end_time_possible_times
    return unless (end_time.to_i < 1) || (end_time.to_i > 24)
    errors.add(:end_time, 'must be between 1 and 24 (1:00 AM and 12:00 AM)')
  end

  def start_time_before_end_time
    return unless start_time.to_i >= end_time.to_i
    errors.add(:start_time, 'must be before end hour')
  end
end
