class RenameVolunteerAvailabilityToAvailability < ActiveRecord::Migration
  def change
    rename_table(:volunteer_availabilities, :availabilities)
  end
end
