class RenameVolunteerSpecialtyToSpecialty < ActiveRecord::Migration
  def change
    rename_table(:volunteer_specialties, :specialties)
  end
end
