class ChangeIndexesOnSpecialtiesJoinTable < ActiveRecord::Migration
  def change
    remove_index(:volunteer_specialties_volunteers, :name => 'vol_specialty_volunteer__id_index')
    remove_index(:volunteer_specialties_volunteers, :name => 'vol_specialty_volunteer_specialty_id_index')
    add_index :volunteer_specialties_volunteers, [:volunteer_id, :volunteer_specialty_id], name: 'vol_specialty_volunteer_id_index', unique: true
  end
end
