namespace :geocode do
  desc 'Geocodes clients and volunteers'
  task "update_coords" => :environment do
    clients = Client.where(latitude: nil, longitude: nil)
    clients.each do |client|
      client.geocode

      if client.save
        puts "Success: client #{client.name}"
      else
        puts "Fail: client #{client.name}"
      end
    end

    volunteers = Volunteer.where(latitude: nil, longitude: nil)
    volunteers.each do |volunteer|
      volunteer.geocode

      if volunteer.save
        puts "Success: volunteer #{volunteer.name}"
      else
        puts "Fail: volunteer #{volunteer.name}"
      end
    end

  end
end
