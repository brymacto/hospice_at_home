require 'rails_helper'

describe AvailabilityService do
  let!(:test_volunteer) { create(:volunteer) }
  let(:params_from_volunteer_show_page) do
    ActionController::Parameters.new(
      'controller' => 'volunteers',
      'action' => 'show',
      'id' => "#{test_volunteer.id}"
    )
  end

  it 'instantiates correctly' do
    test_availability = create(:availability, volunteer_id: test_volunteer.id)
    test_availability_for_other_volunteer = create(:availability, volunteer_id: test_volunteer.id + 1)

    service = described_class.new(params_from_volunteer_show_page)

    expect(service.volunteer).to eql(test_volunteer)
    expect(service.availability).to be_instance_of(Availability)
    expect(service.availabilities).to include(test_availability)
    expect(service.availabilities).to_not include(test_availability_for_other_volunteer)
  end

  it 'sorts volunteer availabilities correctly' do
    availability_2 = create(:availability, volunteer_id: test_volunteer.id, day: 'sunday', start_hour: 9, end_hour: 10)
    availability_4 = create(:availability, volunteer_id: test_volunteer.id, day: 'tuesday', start_hour: 13, end_hour: 14)
    availability_6 = create(:availability, volunteer_id: test_volunteer.id, day: 'thursday', start_hour: 9, end_hour: 10)
    availability_1 = create(:availability, volunteer_id: test_volunteer.id, day: 'sunday', start_hour: 2, end_hour: 3)
    availability_7 = create(:availability, volunteer_id: test_volunteer.id, day: 'thursday', start_hour: 12, end_hour: 14)
    availability_3 = create(:availability, volunteer_id: test_volunteer.id, day: 'tuesday', start_hour: 9, end_hour: 10)
    availability_5 = create(:availability, volunteer_id: test_volunteer.id, day: 'wednesday', start_hour: 9, end_hour: 10)

    service = described_class.new(params_from_volunteer_show_page)

    expect(service.availabilities).to eq(
      [
        availability_1,
        availability_2,
        availability_3,
        availability_4,
        availability_5,
        availability_6,
        availability_7
      ]
    )
  end

  it 'saves a availability' do
    vol_availability_params = generate_availability_params
    service = described_class.new(params_from_volunteer_show_page)

    expect do
      service.new_availability(vol_availability_params)
    end.to change { Availability.count }.by(1)
  end

  it 'confirms when a availability was successfully saved' do
    vol_availability_params = generate_availability_params
    service = described_class.new(params_from_volunteer_show_page)

    result = service.new_availability(vol_availability_params)

    expect(result).to eql(true)
  end

  it 'does not save a availability that has errors' do
    vol_availability_params = generate_availability_params(start_hour: 7, end_hour: 6)
    service = described_class.new(params_from_volunteer_show_page)

    expect do
      service.new_availability(vol_availability_params)
    end.to_not change { Availability.count }
  end

  it 'confirms when a availability was not successfully saved' do
    vol_availability_params = generate_availability_params(start_hour: 7, end_hour: 6)
    service = described_class.new(params_from_volunteer_show_page)

    result = service.new_availability(vol_availability_params)

    expect(result).to eql(false)
  end

  it 'returns errors for a availability' do
    vol_availability_params = generate_availability_params(start_hour: 7, end_hour: 6)
    service = described_class.new(params_from_volunteer_show_page)

    service.new_availability(vol_availability_params)
    result = service.availability_errors

    expect(result).to eql('Start hour must be before end hour')
  end
end

def generate_availability_params(attrs = {})
  { 'start_hour' => attrs.fetch(:start_hour, 6), 'end_hour' => attrs.fetch(:end_hour, 7), 'day' => attrs.fetch(:day, 'sunday') }
end
