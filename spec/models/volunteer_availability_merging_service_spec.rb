require 'rails_helper'

describe VolunteerAvailabilityMergingService do
  let!(:test_volunteer) { create(:volunteer) }

  describe '#merge_volunteer_availability' do
    it 'merges bordering volunteer availabilities' do
      generate_availability({day: 'monday', start_hour: 9, end_hour: 10})
      generate_availability({day: 'monday', start_hour: 10, end_hour: 11})
      service = VolunteerAvailabilityMergingService.new(test_volunteer)

      expect { service.merge_volunteer_availability }.to(
        change { test_volunteer.reload.volunteer_availabilities.size }.by(-1)
      )

      expect(test_volunteer.reload.volunteer_availabilities).to include_availability(VolunteerAvailability.new(start_hour: 9, end_hour: 11, day: 'monday', volunteer: test_volunteer))
    end

    it 'does not merge non-bordering volunteer availabilities' do
      generate_availability({day: 'monday', start_hour: 9, end_hour: 10})
      generate_availability({day: 'monday', start_hour: 11, end_hour: 12})
      service = VolunteerAvailabilityMergingService.new(test_volunteer)

      expect { service.merge_volunteer_availability }.to_not(
        change { test_volunteer.reload.volunteer_availabilities }
      )
    end

    it 'does not merge availabilities that merge at midnight, and are on different days' do
      generate_availability({day: 'monday', start_hour: 23, end_hour: 24})
      generate_availability({day: 'monday', start_hour: 0, end_hour: 1})
      service = VolunteerAvailabilityMergingService.new(test_volunteer)

      expect { service.merge_volunteer_availability }.to_not(
        change { test_volunteer.reload.volunteer_availabilities }
      )
    end

    it 'does not duplicate merged availabilities (using @availabilities_already_merged)' do
      generate_availability({day: 'monday', start_hour: 9, end_hour: 10})
      generate_availability({day: 'monday', start_hour: 10, end_hour: 12})
      service = VolunteerAvailabilityMergingService.new(test_volunteer)

      expect { service.merge_volunteer_availability }.to_not(
        change { test_volunteer.reload.volunteer_availabilities }
      )

      expect(test_volunteer.reload.volunteer_availabilities).to includes_only_one_availability(VolunteerAvailability.new(start_hour: 9, end_hour: 12, day: 'monday', volunteer: test_volunteer))
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

RSpec::Matchers.define :include_availability do |availability_being_compared|
  match do |availabilities|
    availabilities.any? do |availability|
      availability.day == availability_being_compared.day &&
        availability.start_hour == availability_being_compared.start_hour &&
        availability.end_hour == availability_being_compared.end_hour &&
        availability.volunteer == availability_being_compared.volunteer
    end
  end
end


RSpec::Matchers.define :includes_only_one_availability do |availability_being_compared|
  match do |availabilities|
    availabilities.one? do |availability|
      availability.day == availability_being_compared.day &&
        availability.start_hour == availability_being_compared.start_hour &&
        availability.end_hour == availability_being_compared.end_hour &&
        availability.volunteer == availability_being_compared.volunteer
    end
  end
end