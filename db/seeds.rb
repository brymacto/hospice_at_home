# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

30.times do
  Volunteer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  Client.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
end

15.times do
  Match.create(
    client_id: Client.order('RANDOM()').first.id,
    volunteer_id: Volunteer.order('RANDOM()').first.id,
    day: %w(monday tuesday wednesday thursday friday).sample,
    start_time: [9, 10, 11].sample,
    end_time: [12, 13, 14].sample)
end

60.times do
  VolunteerAvailability.create(
    volunteer_id: Volunteer.order('RANDOM()').first.id,
    start_hour: [9, 10, 13].sample,
    end_hour: [14, 16, 17].sample,
    day: %w(monday tuesday wednesday thursday friday saturday sunday).sample
  )
end

10.times do
  match_proposal_params = ActionController::Parameters.new(
    day: %w(monday tuesday wednesday thursday friday).sample,
    start_time: [9, 10, 11].sample,
    end_time: [12, 13, 14].sample,
    client_id: Client.order('RANDOM()').first.id,
    status: 'pending',
    match_requests_attributes: {
      '0' => {
        volunteer_id: Volunteer.order('RANDOM()').first.id,
        status: 'pending'
      },
      '1' => {
        volunteer_id: Volunteer.order('RANDOM()').first.id,
        status: 'pending'
      },
      '2' => {
        volunteer_id: Volunteer.order('RANDOM()').first.id,
        status: 'pending'
      }
    }
  )

  CreateMatchProposal.new(match_proposal_params)
end
