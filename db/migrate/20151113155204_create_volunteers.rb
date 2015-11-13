class CreateVolunteers < ActiveRecord::Migration
  def change
    create_table :volunteers do |t|
      t.string :last_name
      t.string :first_name
    end
  end
end
