class AddTimestampsToVolunteersAndSpecialties < ActiveRecord::Migration
  def change
    add_timestamps(:volunteers)
    add_timestamps(:volunteer_specialties)
  end
end
