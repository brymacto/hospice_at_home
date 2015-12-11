class CreateMatchRequest < ActiveRecord::Migration
  def change
    create_table :match_requests do |t|
      t.integer :volunteer_id, null: false
      t.string :status, null: false

      t.timestamps null: false
    end
  end
end
