class AddAddressToVolunteers < ActiveRecord::Migration
  def change
    add_column :volunteers, :longitude, :decimal, precision: 9, scale: 6
    add_column :volunteers, :latitude, :decimal, precision: 9, scale: 6
    add_column :volunteers, :address, :string
    add_column :volunteers, :city, :string
    add_column :volunteers, :province, :string
    add_column :volunteers, :postal_code, :string
  end
end
