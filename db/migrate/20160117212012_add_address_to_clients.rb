class AddAddressToClients < ActiveRecord::Migration
  def change
    add_column :clients, :longitude, :decimal, precision: 9, scale: 6
    add_column :clients, :latitude, :decimal, precision: 9, scale: 6
    add_column :clients, :address, :string
    add_column :clients, :city, :string
    add_column :clients, :province, :string
    add_column :clients, :postal_code, :string
  end
end
