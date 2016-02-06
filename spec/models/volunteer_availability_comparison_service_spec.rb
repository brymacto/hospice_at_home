require 'rails_helper'

describe VolunteerAvailabilityMergingService do
  let!(:test_volunteer) { create(:volunteer) }

  describe '#availabilities_are_duplicates' do
    it 'returns true when availabilities have same day, start hour, and end hour' do
      availability_1 = generate_availability({day: 'monday', start_hour: 9, end_hour: 11})
      availability_2 = generate_availability({day: 'monday', start_hour: 9, end_hour: 11})
      service = VolunteerAvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_duplicates

      expect(result).to eq true
    end

    it 'returns false when availabilities do not have same day, start hour, or end hour' do
      availability_1 = generate_availability({day: 'monday', start_hour: 9, end_hour: 11})
      availability_2 = generate_availability({day: 'tuesday', start_hour: 9, end_hour: 11})
      service = VolunteerAvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_duplicates

      expect(result).to eq false
    end
  end

  describe '#availabilities_are_bordering' do
    it 'returns true when availabilities have the same day and bordering times' do
      availability_1 = generate_availability({day: 'monday', start_hour: 9, end_hour: 11})
      availability_2 = generate_availability({day: 'monday', start_hour: 11, end_hour: 13})
      service = VolunteerAvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_bordering

      expect(result).to eq true
    end

    it 'returns false when availabilities do not have bordering times' do
      availability_1 = generate_availability({day: 'monday', start_hour: 9, end_hour: 11})
      availability_2 = generate_availability({day: 'monday', start_hour: 12, end_hour: 13})
      service = VolunteerAvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_bordering

      expect(result).to eq false
    end

    it 'returns false when availabilities have overlapping times' do
      availability_1 = generate_availability({day: 'monday', start_hour: 9, end_hour: 11})
      availability_2 = generate_availability({day: 'monday', start_hour: 10, end_hour: 12})
      service = VolunteerAvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_bordering

      expect(result).to eq false
    end
  end

  describe '#availabilities_are_overlapping' do
    it 'returns true when availabilities are fully overlapping' do
      availability_1 = generate_availability({day: 'monday', start_hour: 9, end_hour: 12})
      availability_2 = generate_availability({day: 'monday', start_hour: 10, end_hour: 11})
      service = VolunteerAvailabilityComparisonService.new(availability_1, availability_2)

      result = service.availabilities_are_overlapping

      expect(result).to eq true
    end

  end

end

def generate_availability(args = {})
  create(
    :volunteer_availability,
    volunteer_id: test_volunteer.id,
    day: args.fetch(:day, 'monday'),
    start_hour: args.fetch(:start_hour, 9),
    end_hour: args.fetch(:end_hour, 10)
  )
end