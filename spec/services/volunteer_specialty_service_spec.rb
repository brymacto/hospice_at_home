require 'rails_helper'

describe VolunteerAvailabilityService do
  let!(:test_volunteer) { create(:volunteer, first_name: 'Jane', last_name: 'Doe') }
  let(:test_specialty) { create(:volunteer_specialty, name: 'Expressive Arts') }

  let(:params) do
    ActionController::Parameters.new(
      'controller' => 'volunteers',
      'action' => 'add_volunteer_specialty',
      'volunteer' => {
        'volunteer_specialty_ids' => test_specialty.id.to_s
      },
      'id' => "#{test_volunteer.id}"
    )
  end

  it 'instantiates correctly' do
    service = VolunteerSpecialtyService.new(params)

    expect(service.volunteer_specialty.name).to eql('Expressive Arts')
    expect(service.volunteer).to eql(test_volunteer)
    expect(service.flash_message).to be_nil
  end

  describe 'Adding a specialty' do
    it 'adds a specialty' do
      service = VolunteerSpecialtyService.new(params)
      expect do
        service.add_specialty_to_volunteer
        test_volunteer.reload
      end.to change { test_volunteer.volunteer_specialties.size }.by(1)
    end

    it 'responds with true when it adds a specialty' do
      service = VolunteerSpecialtyService.new(params)

      expect(service.add_specialty_to_volunteer).to be true
    end

    it 'fails to add a specialty if it already belongs to the volunteer' do
      service = VolunteerSpecialtyService.new(params)
      service.add_specialty_to_volunteer
      test_volunteer.reload

      expect do
        service.add_specialty_to_volunteer
        test_volunteer.reload
      end.to_not change { test_volunteer.volunteer_specialties.size }
    end

    it 'provides a flash message when it fails to add a specialty' do
      service = VolunteerSpecialtyService.new(params)
      service.add_specialty_to_volunteer
      service.add_specialty_to_volunteer

      expect(service.flash_message).to eql('Jane Doe already has the specialty Expressive Arts')
    end

    it 'responds with false when it fails to add a specialty' do
      service = VolunteerSpecialtyService.new(params)
      service.add_specialty_to_volunteer

      expect(service.add_specialty_to_volunteer).to be false
    end
  end

  describe 'Removing a specialty' do
    it 'removes a specialty' do
      service = VolunteerSpecialtyService.new(params)
      service.add_specialty_to_volunteer

      expect do
        service.remove_specialty_from_volunteer
      end.to change { test_volunteer.reload.volunteer_specialties.size }.by(-1)
    end

    it 'fails to remove a specialty if it does not belong to the volunteer' do
      service = VolunteerSpecialtyService.new(params)

      expect do
        service.remove_specialty_from_volunteer
      end.to_not change { test_volunteer.reload.volunteer_specialties.size }
    end
  end
end
