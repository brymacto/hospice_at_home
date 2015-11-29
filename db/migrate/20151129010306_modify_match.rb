class ModifyMatch < ActiveRecord::Migration
  def change
    change_table :matches do |t|
      t.change :day, :string, null: false
      t.change :start_time, :integer, null: false
      t.change :end_time, :integer, null: false
    end
  end
end
