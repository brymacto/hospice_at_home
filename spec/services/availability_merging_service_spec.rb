require 'rails_helper'

describe AvailabilityMergingService do
  let!(:test_volunteer) { create(:volunteer) }

  describe 'flash_message' do
    it 'returns no flash message if no merges are executed' do
      generate_availability(day: 'monday', start_time: 9, end_time: 10)
      generate_availability(day: 'monday', start_time: 12, end_time: 14)
      service = described_class.new(test_volunteer)

      service.merge

      expect(service.flash_message).to be_nil
    end

    it 'returns correct flash message if one merge was executed' do
      generate_availability(day: 'monday', start_time: 9, end_time: 10)
      generate_availability(day: 'monday', start_time: 10, end_time: 11)
      service = described_class.new(test_volunteer)

      service.merge

      expect(service.flash_message).to eq('The following availabilities have been merged: Monday, from 9 to 10 and from 10 to 11')
    end

    it 'returns correct flash message if multiple merges were executed' do
      generate_availability(day: 'monday', start_time: 9, end_time: 10)
      generate_availability(day: 'monday', start_time: 10, end_time: 11)

      generate_availability(day: 'tuesday', start_time: 9, end_time: 12)
      generate_availability(day: 'tuesday', start_time: 10, end_time: 11)
      service = described_class.new(test_volunteer)

      service.merge

      expect(service.flash_message).to eq('The following availabilities have been merged: Monday, from 9 to 10 and from 10 to 11; Tuesday, from 9 to 12 and from 10 to 11')
    end
  end

  describe '#merge_availability' do
    it 'merges duplicate volunteer availabilities' do
      generate_availability(day: 'monday', start_time: 9, end_time: 10)
      generate_availability(day: 'monday', start_time: 9, end_time: 10)
      service = described_class.new(test_volunteer)

      expect { service.merge }.to(
        change { test_volunteer.reload.availabilities.size }.by(-1)
      )

      expect(test_volunteer.reload.availabilities).to include_availability(Availability.new(start_time: 9, end_time: 10, day: 'monday', volunteer: test_volunteer))
    end

    it 'merges partially overlapping volunteer availabilities' do
      generate_availability(day: 'monday', start_time: 9, end_time: 11)
      generate_availability(day: 'monday', start_time: 7, end_time: 10)
      service = described_class.new(test_volunteer)

      expect { service.merge }.to(
        change { test_volunteer.reload.availabilities.size }.by(-1)
      )

      expect(test_volunteer.reload.availabilities).to include_availability(Availability.new(start_time: 7, end_time: 11, day: 'monday', volunteer: test_volunteer))
    end

    it 'merges fully overlapping volunteer availabilities' do
      generate_availability(day: 'monday', start_time: 9, end_time: 10)
      generate_availability(day: 'monday', start_time: 8, end_time: 11)
      service = described_class.new(test_volunteer)

      expect { service.merge }.to(
        change { test_volunteer.reload.availabilities.size }.by(-1)
      )
      expect(test_volunteer.reload.availabilities).to include_availability(Availability.new(start_time: 8, end_time: 11, day: 'monday', volunteer: test_volunteer))
    end

    it 'merges bordering volunteer availabilities' do
      generate_availability(day: 'monday', start_time: 9, end_time: 10)
      generate_availability(day: 'monday', start_time: 10, end_time: 11)
      service = described_class.new(test_volunteer)

      expect { service.merge }.to(
        change { test_volunteer.reload.availabilities.size }.by(-1)
      )

      expect(test_volunteer.reload.availabilities).to include_availability(Availability.new(start_time: 9, end_time: 11, day: 'monday', volunteer: test_volunteer))
    end

    it 'does not merge non-bordering volunteer availabilities' do
      generate_availability(day: 'monday', start_time: 9, end_time: 10)
      generate_availability(day: 'monday', start_time: 11, end_time: 12)
      service = described_class.new(test_volunteer)

      expect { service.merge }.to_not(
        change { test_volunteer.reload.availabilities }
      )
    end

    it 'does not merge availabilities that merge at midnight, and are on different days' do
      generate_availability(day: 'monday', start_time: 23, end_time: 24)
      generate_availability(day: 'monday', start_time: 0, end_time: 1)
      service = described_class.new(test_volunteer)

      expect { service.merge }.to_not(
        change { test_volunteer.reload.availabilities }
      )
    end

    it 'does not duplicate merged availabilities (using @availabilities_already_merged)' do
      generate_availability(day: 'monday', start_time: 9, end_time: 10)
      generate_availability(day: 'monday', start_time: 10, end_time: 12)
      service = described_class.new(test_volunteer)

      expect { service.merge }.to_not(
        change { test_volunteer.reload.availabilities }
      )

      expect(test_volunteer.reload.availabilities).to includes_only_one_availability(Availability.new(start_time: 9, end_time: 12, day: 'monday', volunteer: test_volunteer))
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

RSpec::Matchers.define :include_availability do |availability_being_compared|
  match do |availabilities|
    availabilities.any? do |availability|
      availability.day == availability_being_compared.day &&
        availability.start_time == availability_being_compared.start_time &&
        availability.end_time == availability_being_compared.end_time &&
        availability.volunteer == availability_being_compared.volunteer
    end
  end
end

RSpec::Matchers.define :includes_only_one_availability do |availability_being_compared|
  match do |availabilities|
    availabilities.one? do |availability|
      availability.day == availability_being_compared.day &&
        availability.start_time == availability_being_compared.start_time &&
        availability.end_time == availability_being_compared.end_time &&
        availability.volunteer == availability_being_compared.volunteer
    end
  end
end
