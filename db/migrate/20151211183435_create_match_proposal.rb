class CreateMatchProposal < ActiveRecord::Migration
  def change
    create_table :match_proposals do |t|
      t.string :day, null: false
      t.integer :start_time, null: false
      t.integer :end_time, null: false
      t.integer :client_id, null: false
      t.string :status, null: false

      t.timestamps null: false
    end
  end
end
