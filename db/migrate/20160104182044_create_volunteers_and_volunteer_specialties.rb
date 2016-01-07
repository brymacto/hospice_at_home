class CreateVolunteersAndVolunteerSpecialties < ActiveRecord::Migration
  def change
    create_table :volunteer_specialties_volunteers, id: false do |t|
      t.belongs_to :volunteer
      t.belongs_to :volunteer_specialty
    end
    add_index :volunteer_specialties_volunteers, [:volunteer_id], name: 'vol_specialty_volunteer__id_index', unique: true
    add_index :volunteer_specialties_volunteers, [:volunteer_specialty_id], name: 'vol_specialty_volunteer_specialty_id_index', unique: true
  end
end
