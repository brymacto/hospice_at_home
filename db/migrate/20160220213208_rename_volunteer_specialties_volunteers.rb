class RenameVolunteerSpecialtiesVolunteers < ActiveRecord::Migration
  def change
    rename_table(:volunteer_specialties_volunteers, :specialties_volunteers)
    rename_column :specialties_volunteers, :volunteer_specialty_id, :specialty_id
  end
end


