class AddDayStartHourEndHourToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :day, :string
    add_column :matches, :start_time, :integer
    add_column :matches, :end_time, :integer


  end
end
