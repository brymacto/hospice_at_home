require 'rails_helper'

describe AvailabilityMergingService do
  let!(:test_volunteer) { create(:volunteer) }

  describe '#availabilities_are_duplicates' do
    it 'returns true when availabilities have same day, start time, and end time' do
      availability_1 = generate_availability(day: 'monday', start_time: 9, end_time: 11)
      availability_2 = generate_availability(day: 'monday', start_time: 9, end_time: 11)
      service = AvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_duplicates

      expect(result).to eq true
    end

    it 'returns false when availabilities do not have same day, start time, or end time' do
      availability_1 = generate_availability(day: 'monday', start_time: 9, end_time: 11)
      availability_2 = generate_availability(day: 'tuesday', start_time: 9, end_time: 11)
      service = AvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_duplicates

      expect(result).to eq false
    end
  end

  describe '#availabilities_are_bordering' do
    it 'returns true when availabilities have the same day and bordering times' do
      availability_1 = generate_availability(day: 'monday', start_time: 9, end_time: 11)
      availability_2 = generate_availability(day: 'monday', start_time: 11, end_time: 13)
      service = AvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_bordering

      expect(result).to eq true
    end

    it 'returns false when availabilities do not have bordering times' do
      availability_1 = generate_availability(day: 'monday', start_time: 9, end_time: 11)
      availability_2 = generate_availability(day: 'monday', start_time: 12, end_time: 13)
      service = AvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_bordering

      expect(result).to eq false
    end

    it 'returns false when availabilities have overlapping times' do
      availability_1 = generate_availability(day: 'monday', start_time: 9, end_time: 11)
      availability_2 = generate_availability(day: 'monday', start_time: 10, end_time: 12)
      service = AvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_bordering

      expect(result).to eq false
    end
  end

  describe '#availabilities_are_overlapping' do
    it 'returns true when availabilities are fully overlapping' do
      availability_1 = generate_availability(day: 'monday', start_time: 9, end_time: 12)
      availability_2 = generate_availability(day: 'monday', start_time: 10, end_time: 11)
      service = AvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_overlapping

      expect(result).to eq true
    end

    it 'returns true when availabilities are partially overlapping for both start and end time' do
      availability_1 = generate_availability(day: 'monday', start_time: 9, end_time: 12)
      availability_2 = generate_availability(day: 'monday', start_time: 8, end_time: 11)
      service = AvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_overlapping

      expect(result).to eq true
    end

    it 'returns true when availabilities are partially overlapping for one time, equal for other time' do
      availability_1 = generate_availability(day: 'monday', start_time: 9, end_time: 12)
      availability_2 = generate_availability(day: 'monday', start_time: 10, end_time: 12)
      service = AvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_overlapping

      expect(result).to eq true
    end
  end
end

def generate_availability(args = {})
  create(
    :availability,
    volunteer_id: test_volunteer.id,
    day: args.fetch(:day, 'monday'),
    start_time: args.fetch(:start_time, 9),
    end_time: args.fetch(:end_time, 10)
  )
end
