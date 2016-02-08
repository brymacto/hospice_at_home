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
      :availability,
      day: 'monday',
      start_time: 14,
      end_time: 16,
      volunteer_id: volunteer_with_availability.id)
  end

  let!(:test_availability_2) do
    FactoryGirl.create(
      :availability,
      day: 'tuesday',
      start_time: 0,
      end_time: 24,
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

  describe '#address_changed?' do
    let!(:test_volunteer) do
      FactoryGirl.create(:volunteer)
    end

    it 'returns true when address updated' do
      test_volunteer.address = '1 Yonge St.'
      expect(test_volunteer.any_address_changed?).to eql(true)
    end

    it 'returns true when city updated' do
      test_volunteer.city = 'Scarborough'
      expect(test_volunteer.any_address_changed?).to eql(true)
    end

    it 'returns true when province updated' do
      test_volunteer.province = 'QC'
      expect(test_volunteer.any_address_changed?).to eql(true)
    end

    it 'returns true when postal code updated' do
      test_volunteer.postal_code = 'M5V 1M1'
      expect(test_volunteer.any_address_changed?).to eql(true)
    end

    it 'returns false or nil when non-address field is updated' do
      test_volunteer.first_name = 'Bob'
      expect(test_volunteer.any_address_changed?).to_not eql(true)
    end
  end
end
