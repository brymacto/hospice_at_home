require 'rails_helper'

describe VolunteerAvailabilityMergingService do
  let!(:test_volunteer) { create(:volunteer) }
  let!(:bordering_availability_1) { generate_availability({day: 'monday', start_time: 9, end_time: 10}) }
  let!(:bordering_availability_2) { generate_availability({day: 'monday', start_time: 10, end_time: 11}) }
  let!(:nonbordering_availability) { generate_availability({day: 'tuesday', start_time: 10, end_time: 11}) }

  describe '#merge_volunteer_availability' do
    it 'merges bordering volunteer availabilities' do
      service = VolunteerAvailabilityMergingService.new(test_volunteer)

      expect do
        service.merge_volunteer_availability
      end.to change { test_volunteer.reload.volunteer_availabilities.size }.by(-1)
    end

    xit 'does not merge non-bordering volunteer availabilities' do

    end

    xit 'does not merge availabilities that merge at midnight, and are on different days' do

    end
  end
end

def generate_availability(args = {})
  create(
    :volunteer_availability,
    volunteer_id: test_volunteer.id,
    day: args.fetch(:day, 'monday'),
    start_time: args.fetch(:start_time, 9),
    end_time: args.fetch(:end_time, 10)
  )
end