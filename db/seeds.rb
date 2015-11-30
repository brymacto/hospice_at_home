# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do
  Volunteer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  Client.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
end

10.times do
  VolunteerAvailability.create(volunteer_id: Volunteer.order('RANDOM()').first.id, start_hour: [9, 10, 13].sample, end_hour: [14, 16, 17].sample, day: %w(monday tuesday).sample)
end
