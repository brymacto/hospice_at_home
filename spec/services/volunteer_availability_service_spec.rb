require 'rails_helper'

describe VolunteerAvailabilityService do
  let!(:test_volunteer) { create(:volunteer) }
  let(:params_from_volunteer_show_page) do
    ActionController::Parameters.new(
      'controller' => 'volunteers',
      'action' => 'show',
      'id' => "#{test_volunteer.id}"
    )
  end

  it 'instantiates correctly' do
    test_availability = create(:volunteer_availability, volunteer_id: test_volunteer.id)
    test_availability_for_other_volunteer = create(:volunteer_availability, volunteer_id: test_volunteer.id + 1)

    service = VolunteerAvailabilityService.new(params_from_volunteer_show_page)

    expect(service.volunteer).to eql(test_volunteer)
    expect(service.volunteer_availability).to be_instance_of(VolunteerAvailability)
    expect(service.volunteer_availabilities).to include(test_availability)
    expect(service.volunteer_availabilities).to_not include(test_availability_for_other_volunteer)
  end

  it 'sorts volunteer availabilities correctly' do
    availability_2 = create(:volunteer_availability, volunteer_id: test_volunteer.id, day: 'sunday', start_hour: 9, end_hour: 10)
    availability_4 = create(:volunteer_availability, volunteer_id: test_volunteer.id, day: 'tuesday', start_hour: 13, end_hour: 14)
    availability_6 = create(:volunteer_availability, volunteer_id: test_volunteer.id, day: 'thursday', start_hour: 9, end_hour: 10)
    availability_1 = create(:volunteer_availability, volunteer_id: test_volunteer.id, day: 'sunday', start_hour: 2, end_hour: 3)
    availability_7 = create(:volunteer_availability, volunteer_id: test_volunteer.id, day: 'thursday', start_hour: 12, end_hour: 14)
    availability_3 = create(:volunteer_availability, volunteer_id: test_volunteer.id, day: 'tuesday', start_hour: 9, end_hour: 10)
    availability_5 = create(:volunteer_availability, volunteer_id: test_volunteer.id, day: 'wednesday', start_hour: 9, end_hour: 10)

    service = VolunteerAvailabilityService.new(params_from_volunteer_show_page)

    expect(service.volunteer_availabilities).to eq(
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

  it 'saves a volunteer availability' do
    vol_availability_params = generate_volunteer_availability_params
    service = VolunteerAvailabilityService.new(params_from_volunteer_show_page)

    expect do
      service.new_volunteer_availability(vol_availability_params)
    end.to change { VolunteerAvailability.count }.by(1)
  end

  it 'confirms when a volunteer availability was successfully saved' do
    vol_availability_params = generate_volunteer_availability_params
    service = VolunteerAvailabilityService.new(params_from_volunteer_show_page)

    result = service.new_volunteer_availability(vol_availability_params)

    expect(result).to eql(true)
  end

  it 'does not save a volunteer availability that has errors' do
    vol_availability_params = generate_volunteer_availability_params(start_hour: 7, end_hour: 6)
    service = VolunteerAvailabilityService.new(params_from_volunteer_show_page)

    expect do
      service.new_volunteer_availability(vol_availability_params)
    end.to_not change { VolunteerAvailability.count }
  end

  it 'confirms when a volunteer availability was not successfully saved' do
    vol_availability_params = generate_volunteer_availability_params(start_hour: 7, end_hour: 6)
    service = VolunteerAvailabilityService.new(params_from_volunteer_show_page)

    result = service.new_volunteer_availability(vol_availability_params)

    expect(result).to eql(false)
  end

  it 'returns errors for a volunteer availability' do
    vol_availability_params = generate_volunteer_availability_params(start_hour: 7, end_hour: 6)
    service = VolunteerAvailabilityService.new(params_from_volunteer_show_page)

    service.new_volunteer_availability(vol_availability_params)
    result = service.volunteer_availability_errors

    expect(result).to eql('Start hour must be before end hour')
  end
end

def generate_volunteer_availability_params(attrs = {})
  { 'start_hour' => attrs.fetch(:start_hour, 6), 'end_hour' => attrs.fetch(:end_hour, 7), 'day' => attrs.fetch(:day, 'sunday') }
end
