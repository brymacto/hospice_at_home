class CreateVolunteerSpecialties < ActiveRecord::Migration
  def change
    create_table :volunteer_specialties do |t|
      t.string :name
    end
  end
end
