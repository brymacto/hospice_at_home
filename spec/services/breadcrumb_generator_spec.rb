require 'rails_helper'
include BreadcrumbGenerator

describe BreadcrumbGenerator do
  describe '#load_breadcrumbs' do
    let!(:test_volunteer) do
      FactoryGirl.create(:volunteer, first_name: :Jane, last_name: :Doe)
    end

    let!(:test_specialty) do
      FactoryGirl.create(:specialty)
    end

    it 'works with a class only' do
      expect(load_breadcrumbs(crumb_class: Volunteer)).to(
        eql(
          [{ path: 'http://localhost:3000/volunteers', name: 'Volunteers' }]
        )
      )
    end

    it 'works with a class and an instance' do
      expect(load_breadcrumbs(crumb_class: Volunteer, crumb_instance: test_volunteer)).to(
        eql(
          [
            { path: 'http://localhost:3000/volunteers', name: 'Volunteers' },
            { path: "http://localhost:3000/volunteers/#{test_volunteer.id}", name: 'Jane Doe' }
          ]
        )
      )
    end

    it 'works with a class, an instance, and an action' do
      expect(load_breadcrumbs(crumb_class: Volunteer, crumb_instance: test_volunteer, crumb_actions: [:edit])).to(
        eql(
          [
            { path: 'http://localhost:3000/volunteers', name: 'Volunteers' },
            { path: "http://localhost:3000/volunteers/#{test_volunteer.id}", name: 'Jane Doe' },
            { path: "http://localhost:3000/volunteers/#{test_volunteer.id}/edit", name: 'Edit' }
          ]
        )
      )
    end

    it 'raises an error when the action is not an array' do
      # expect(load_breadcrumbs(crumb_class: Volunteer, crumb_instance: test_volunteer, crumb_actions: :edit)).
      expect { load_breadcrumbs(crumb_actions: :edit) }.to raise_error('Crumb actions must be provided as an Array')
    end

    it 'works with a class, and an action, but no instance' do
      expect(load_breadcrumbs(crumb_class: Volunteer, crumb_actions: [:new])).to(
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
        expect(load_breadcrumbs(crumb_class: MatchProposal)[0][:name]).to eql('Match proposals')
      end

      it 'correctly generates a path for a controller that has two words in its name' do
        expect(load_breadcrumbs(crumb_class: Specialty, crumb_instance: test_specialty, crumb_actions: [:edit])[1][:path]).to(
          eql("http://localhost:3000/specialties/#{test_specialty.id}")
        )
      end

      it 'correctly generates Match Explorer breadcrumb' do
        expect(load_breadcrumbs(crumb_class: Match, crumb_actions: [:match_explorer])[1][:name]).to eql('Match explorer')
        expect(load_breadcrumbs(crumb_class: Match, crumb_actions: [:match_explorer])[1][:path]).to eql('/matches/explorer')
      end
    end
  end
end
