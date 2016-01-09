class AddTimestampsToClients < ActiveRecord::Migration
  def change
    add_timestamps(:clients)
  end
end
