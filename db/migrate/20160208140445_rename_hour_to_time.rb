class RenameHourToTime < ActiveRecord::Migration
  def change
    rename_column :availabilities, :start_hour, :start_time
    rename_column :availabilities, :end_hour, :end_time
  end
end
