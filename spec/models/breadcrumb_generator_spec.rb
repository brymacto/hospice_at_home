require 'rails_helper'
include BreadcrumbGenerator

describe BreadcrumbGenerator do
  describe '#load_breadcrumbs' do
    let!(:test_volunteer) do
      FactoryGirl.create(:volunteer, first_name: :Jane, last_name: :Doe)
    end

    let!(:test_volunteer_specialty) do
      FactoryGirl.create(:volunteer_specialty)
    end

    it 'works with a class only' do
      expect(load_breadcrumbs(Volunteer)).to(
        eql(
          [{ path: 'http://localhost:3000/volunteers', name: 'Volunteers' }]
        )
      )
    end

    it 'works with a class and an object' do
      expect(load_breadcrumbs(Volunteer, test_volunteer)).to(
        eql(
          [
            { path: 'http://localhost:3000/volunteers', name: 'Volunteers' },
            { path: "http://localhost:3000/volunteers/#{test_volunteer.id}", name: 'Jane Doe' }
          ]
        )
      )
    end

    it 'works with a class, an object, and an action' do
      expect(load_breadcrumbs(Volunteer, test_volunteer, :edit)).to(
        eql(
          [
            { path: 'http://localhost:3000/volunteers', name: 'Volunteers' },
            { path: "http://localhost:3000/volunteers/#{test_volunteer.id}", name: 'Jane Doe' },
            { path: "http://localhost:3000/volunteers/#{test_volunteer.id}/edit", name: 'Edit' }
          ]
        )
      )
    end

    it 'works with a class, and an action, but no object' do
      expect(load_breadcrumbs(Volunteer, nil, :new)).to(
        eql(
          [
            { path: 'http://localhost:3000/volunteers', name: 'Volunteers' },
            { path: 'http://localhost:3000/volunteers/new', name: 'New' }
          ]
        )
      )
    end

    describe 'special cases' do
      it 'correctly labels a class that has two words in its name' do
        expect(load_breadcrumbs(MatchProposal)[0][:name]).to eql('Match proposals')
      end

      it 'correctly labels VolunteerSpecialty class as Specialties' do
        expect(load_breadcrumbs(VolunteerSpecialty)[0][:name]).to eql('Specialties')
      end

      it 'correctly generates a path for a controller that has two words in its name' do
        expect(load_breadcrumbs(VolunteerSpecialty, test_volunteer_specialty, :edit)[1][:path]).to(
          eql("http://localhost:3000/volunteer_specialties/#{test_volunteer_specialty.id}")
        )
      end

      it 'correctly generates Match Explorer breadcrumb' do
        expect(load_breadcrumbs(Match, nil, :match_explorer)[1][:name]).to eql('Match explorer')
        expect(load_breadcrumbs(Match, nil, :match_explorer)[1][:path]).to eql('/matches/explorer')
      end
    end
  end
end
