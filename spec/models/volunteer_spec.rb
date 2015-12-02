require 'rails_helper'

describe Volunteer do
  let!(:volunteer_with_availability) do
    FactoryGirl.create(:volunteer)
  end
  let!(:volunteer_without_availability) do
    FactoryGirl.create(:volunteer)
  end
  let!(:test_availability) do
    FactoryGirl.create(
      :volunteer_availability,
      day: 'monday',
      start_hour: 14,
      end_hour: 16,
      volunteer_id: volunteer_with_availability.id)
  end
  let!(:test_availability_2) do
    FactoryGirl.create(
        :volunteer_availability,
        day: 'tuesday',
        start_hour: 0,
        end_hour: 24,
        volunteer_id: volunteer_with_availability.id)
  end
  describe '#available?' do
    it 'is available when volunteer has matching availability' do
      expect(volunteer_with_availability).to be_available(TimeRange.new('monday', 14, 16))
    end

    it 'is available when volunteer has matching availability (available ALL day' do
      expect(volunteer_with_availability).to be_available(TimeRange.new('tuesday', 10, 11))
    end

    it 'is not available when volunteer does not have matching availability' do
      expect(volunteer_with_availability).to_not be_available(TimeRange.new('sunday', 10, 11))
    end

    it 'is not available when volunteer has matching availability for only portion of shift' do
      expect(volunteer_with_availability).to_not be_available(TimeRange.new('sunday', 10, 15))
    end

    it 'is not available when volunteer has no availabilities' do
      expect(volunteer_without_availability).to_not be_available(TimeRange.new('sunday', 10, 15))
    end
  end
end
