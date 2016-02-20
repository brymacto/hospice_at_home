class CreateVolunteerAvailability < ActiveRecord::Migration
  def change
    create_table :volunteer_availabilities do |t|
      t.string :day, null: false
      t.integer :start_hour, null: false
      t.integer :end_hour, null: false
      t.integer :volunteer_id, null: false

      t.timestamps null: false
    end
  end
end
