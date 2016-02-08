class RenameHourToTime < ActiveRecord::Migration
  def change
    rename_column :availabilities, :start_time, :start_time
    rename_column :availabilities, :end_time, :end_time
  end
end
