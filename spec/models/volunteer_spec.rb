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
  describe '#available?' do
    it 'is available when volunteer has matching availability' do
      expect(volunteer_with_availability.available?(TimeRange.new('monday', 14, 16))).to eq(true)
    end

    it 'is not available when volunteer does not have matching availability' do
      expect(volunteer_with_availability.available?(TimeRange.new('sunday', 10, 11))).to eq(false)
    end

    it 'is not available when volunteer has matching availability for only portion of shift' do
      expect(volunteer_with_availability.available?(TimeRange.new('sunday', 10, 15))).to eq(false)
    end

    it 'is not available when volunteer has no availabilities' do
      expect(volunteer_without_availability.available?(TimeRange.new('sunday', 10, 15))).to eq(false)
    end
  end
end
