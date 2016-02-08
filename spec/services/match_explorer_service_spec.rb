require 'rails_helper'

describe MatchExplorerService do
  let(:test_client) { create(:client) }

  let(:test_specialty) { create(:volunteer_specialty, name: 'Expressive Arts') }

  let!(:test_client) do
    create(:client,
           first_name: 'Brian',
           last_name: 'Blaine')
  end

  let(:params_without_specialty) do
    ActionController::Parameters.new(
      'client_id' => test_client.id.to_s,
      'day' => 'monday',
      'start_time' => 10,
      'end_time' => 11
    )
  end

  let(:params_with_specialty) do
    ActionController::Parameters.new(
      'client_id' => test_client.id.to_s,
      'day' => 'monday',
      'start_time' => 10,
      'end_time' => 11,
      'specialty_id' => test_specialty.id.to_s
    )
  end

  it 'provides an invalid match exploration if no params provided' do
    service = described_class.new(nil)

    expect(service.match_exploration.valid?).to be false
  end

  it 'provides a valid match exploration if params provided' do
    service = described_class.new(params_with_specialty)

    expect(service.match_exploration.valid?).to be true
  end

  describe '#volunteers' do
    let!(:test_volunteer_available) do
      create(:volunteer,
             first_name: 'John',
             last_name: 'Smith')
    end

    let!(:test_volunteer_not_available) do
      create(:volunteer,
             first_name: 'Jane',
             last_name: 'Doe')
    end

    let!(:test_volunteer_availability) do
      create(:volunteer_availability,
             volunteer_id: test_volunteer_available.id,
             day: 'monday',
             start_hour: 10,
             end_hour: 24)
    end

    it 'provides correct volunteers for given time with no specialty specified' do
      service = described_class.new(params_without_specialty)

      expect(service.volunteers).to include test_volunteer_available
      expect(service.volunteers).to_not include test_volunteer_not_available
    end

    it 'provides correct volunteers for given time with specialty specified' do
      test_volunteer_with_specialty = create(:volunteer)
      create(:volunteer_availability,
             volunteer_id: test_volunteer_with_specialty.id,
             day: 'monday',
             start_hour: 10,
             end_hour: 24)
      test_volunteer_with_specialty.volunteer_specialties << test_specialty

      service = described_class.new(params_with_specialty)

      expect(service.volunteers).to include test_volunteer_with_specialty
      expect(service.volunteers).to_not include test_volunteer_available
      expect(service.volunteers).to_not include test_volunteer_not_available
    end
  end
end
