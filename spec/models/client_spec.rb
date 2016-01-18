require 'rails_helper'

describe Client do
  let!(:test_client) do
    FactoryGirl.create(:client)
  end
  describe '#address_changed?' do
    it 'returns true when address updated' do
      test_client.address = '1 Yonge St.'
      expect(test_client.any_address_changed?).to eql(true)
    end

    it 'returns true when city updated' do
      test_client.city = 'Scarborough'
      expect(test_client.any_address_changed?).to eql(true)
    end

    it 'returns true when province updated' do
      test_client.province = 'QC'
      expect(test_client.any_address_changed?).to eql(true)
    end

    it 'returns true when postal code updated' do
      test_client.postal_code = 'M5V 1M1'
      expect(test_client.any_address_changed?).to eql(true)
    end

    it 'returns false or nil when non-address field is updated' do
      test_client.first_name = 'Bob'
      expect(test_client.any_address_changed?).to_not eql(true)
    end
  end
end
