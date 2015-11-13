class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :client_id, null: false
      t.integer :volunteer_id, null: false

      t.timestamps null: false
    end
  end
end
