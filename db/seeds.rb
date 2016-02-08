# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Source for seed addresses: http://www1.toronto.ca/wps/portal/contentonly?vgnextoid=4f6bdda2f1405410VgnVCM10000071d60f89RCRD&vgnextchannel=75d6e03bb8d1e310VgnVCM10000071d60f89RCRD
SEED_ADDRESSES = [{ address: '925 Albion Road', city: 'Toronto', province: 'ON', postal_code: 'M9V 1A6' }, { address: '1485 Albion Road', city: 'Toronto', province: 'ON', postal_code: 'M9V 1B2' }, { address: '1515 Albion Road', city: 'Toronto', province: 'ON', postal_code: 'M9V 1B2' }, { address: '21 College Street', city: 'Toronto', province: 'ON', postal_code: 'M5G 2B3' }, { address: '203 Humber College Boulevard', city: 'Toronto', province: 'ON', postal_code: 'M9W 5L7' }, { address: '2534 Kipling Avenue', city: 'Toronto', province: 'ON', postal_code: 'M9V 3A9' }, { address: '2580 Kipling Avenue', city: 'Toronto', province: 'ON', postal_code: 'M9V 3B2' }, { address: '175 Mount Olive Drive', city: 'Toronto', province: 'ON', postal_code: 'M9V 2E3' }, { address: '21 Panorama Court', city: 'Toronto', province: 'ON', postal_code: 'M9V 4E3' }, { address: '10 Rampart Road', city: 'Toronto', province: 'ON', postal_code: 'M9V 4L9' }, { address: '34 Riverdale Drive', city: 'Toronto', province: 'ON', postal_code: 'M9V 1C8' }, { address: '2 Rowntree Road', city: 'Toronto', province: 'ON', postal_code: 'M9V 5G6' }, { address: '33 Carlson Court', city: 'Toronto', province: 'ON', postal_code: 'M9W 6H5' }, { address: '650 Dixon Road', city: 'Toronto', province: 'ON', postal_code: 'M9W 1J1' }, { address: '650 Dixon Road', city: 'Toronto', province: 'ON', postal_code: 'M9W 1J3' }, { address: '801 Dixon Road', city: 'Toronto', province: 'ON', postal_code: 'M9W 1J5' }, { address: '850 Humberwood Boulevard', city: 'Toronto', province: 'ON', postal_code: 'M9W 7A6' }, { address: '2170 Kipling Avenue', city: 'Toronto', province: 'ON', postal_code: 'M9W 4K9' }, { address: '2243 Kipling Avenue', city: 'Toronto', province: 'ON', postal_code: 'M9W 4L3' }, { address: '2239 Lawrence Avenue East', city: 'Toronto', province: 'ON', postal_code: 'M1P 2P7  ' }, { address: '555 Rexdale Boulevard', city: 'Toronto', province: 'ON', postal_code: 'M9W 5L2' }, { address: '123 Rexdale Boulevard', city: 'Toronto', province: 'ON', postal_code: 'M9W 0B1' }, { address: '2 St. Andrews Boulevard', city: 'Toronto', province: 'ON', postal_code: 'M6P 2R7' }, { address: '31 St. Phillips Road', city: 'Toronto', province: 'ON', postal_code: 'M9P 2N7' }, { address: '1 Vulcan St. ', city: 'Toronto', province: 'ON', postal_code: 'M9W 1L3' }, { address: '2 Elmbrook Crescent', city: 'Toronto', province: 'ON', postal_code: 'M9C 5B4' }, { address: '130 Lloyd Manor Road', city: 'Toronto', province: 'ON', postal_code: 'M9B 5K1' }, { address: '291 Mill Road', city: 'Toronto', province: 'ON', postal_code: 'M9C 1Y5' }, { address: '56 Neilson Drive', city: 'Toronto', province: 'ON', postal_code: 'M9C 1V7' }, { address: '475 Rathburn Road', city: 'Toronto', province: 'ON', postal_code: 'M9C 3S9' }, { address: '590 Rathburn Road', city: 'Toronto', province: 'ON', postal_code: 'M9C 3T3' }, { address: '630 Renforth Drive', city: 'Toronto', province: 'ON', postal_code: 'M9C 2N6' }, { address: '500 The East Mall', city: 'Toronto', province: 'ON', postal_code: 'M9B 4A3' }, { address: '399 The West Mall', city: 'Toronto', province: 'ON', postal_code: 'M9C 2Y2' }, { address: '450 The West Mall', city: 'Toronto', province: 'ON', postal_code: 'M9C 1E9' }, { address: '10 Toledo Road', city: 'Toronto', province: 'ON', postal_code: 'M9C 2H3' }, { address: '50 Winterton Drive', city: 'Toronto', province: 'ON', postal_code: 'M9B 3G9' }, { address: '4709 Dundas Street West', city: 'Toronto', province: 'ON', postal_code: 'M9A 1A8' }, { address: '1806 Islington Avenue', city: 'Toronto', province: 'ON', postal_code: 'M9P 3N3' }, { address: '1428 Royal York Road', city: 'Toronto', province: 'ON', postal_code: 'M9P 3A8 ' }, { address: '15 Trehorne Drive', city: 'Toronto', province: 'ON', postal_code: 'M9P 1N8' }, { address: '76 Anglesey Boulevard', city: 'Toronto', province: 'ON', postal_code: 'M9A 3C1' }, { address: '86 Montgomery Road', city: 'Toronto', province: 'ON', postal_code: 'M9A 3N5' }, { address: '71 Ballacaine Drive', city: 'Toronto', province: 'ON', postal_code: 'M8Y 4B6' }, { address: '2848 Bloor Street West', city: 'Toronto', province: 'ON', postal_code: 'M8X 1A9' }, { address: '2850 Bloor Street West', city: 'Toronto', province: 'ON', postal_code: 'M8X 1B2' }, { address: '3055 Bloor Street West', city: 'Toronto', province: 'ON', postal_code: 'M8X 1C6' }, { address: '3326 Bloor Street West', city: 'Toronto', province: 'ON', postal_code: 'M8X 1E8' }, { address: '4050 Bloor Street West', city: 'Toronto', province: 'ON', postal_code: 'M9B 1M5' }, { address: '36 Brentwood Road North', city: 'Toronto', province: 'ON', postal_code: 'M8X 2B5' }, { address: '25 Burnhamthorpe Road', city: 'Toronto', province: 'ON', postal_code: 'M9A 1G9' }, { address: '430 Burnhamthorpe Road', city: 'Toronto', province: 'ON', postal_code: 'M9B 2B1' }, { address: '15 Canmotor Avenue', city: 'Toronto', province: 'ON', postal_code: 'M8Z 4E4' }, { address: '44 Cordova Avenue', city: 'Toronto', province: 'ON', postal_code: 'M9A 2H5' }, { address: '4893 Dundas Street West', city: 'Toronto', province: 'ON', postal_code: 'M9A 1B2' }, { address: '61 Jutland Road', city: 'Toronto', province: 'ON', postal_code: 'M8Z 2G6' }, { address: '777 Kipling Avenue', city: 'Toronto', province: 'ON', postal_code: 'M8Z 5Z4' }, { address: '105 Norseman Street', city: 'Toronto', province: 'ON', postal_code: 'M8Z 2R1' }, { address: '200 Park Lawn Road', city: 'Toronto', province: 'ON', postal_code: 'M8Y 3J1' }, { address: '277 Park Lawn Road', city: 'Toronto', province: 'ON', postal_code: 'M8Y 3J7' }, { address: '675 Royal York Road', city: 'Toronto', province: 'ON', postal_code: 'M8Y 2T1' }, { address: '851 Royal York Road', city: 'Toronto', province: 'ON', postal_code: 'M8Y 2V3' }, { address: '1536 The Queensway', city: 'Toronto', province: 'ON', postal_code: 'M8Z 1T5' }, { address: '25 The West Mall', city: 'Toronto', province: 'ON', postal_code: 'M9C 1B8' }, { address: '1 Colonel Samuel Smith Park Drive', city: 'Toronto', province: 'ON', postal_code: 'M8V 4B6' }, { address: '21 Colonel Samuel Smith Park Drive', city: 'Toronto', province: 'ON', postal_code: 'M8V 4B6' }, { address: '21 Colonel Samuel Smith Park Drive', city: 'Toronto', province: 'ON', postal_code: 'M8V 4B6' }, { address: '23 Buckingham Street', city: 'Toronto', province: 'ON', postal_code: 'M8Y 1A8' }, { address: '28 Colonel Samuel Smith Park Drive', city: 'Toronto', province: 'ON', postal_code: 'M8V 4B7' }, { address: '110 Eleventh Street', city: 'Toronto', province: 'ON', postal_code: 'M8V 3G5' }, { address: '50 Etta Wylie Road', city: 'Toronto', province: 'ON', postal_code: 'M8V 3Z7' }, { address: '350 Kipling Avenue', city: 'Toronto', province: 'ON', postal_code: 'M8V 3K8' }, { address: '2413 Lake Shore Boulevard West', city: 'Toronto', province: 'ON', postal_code: 'M8V 1C5' }, { address: '2733 Lake Shore Boulevard West', city: 'Toronto', province: 'ON', postal_code: 'M8V 1G9' }, { address: '3199 Lake Shore Boulevard West', city: 'Toronto', province: 'ON', postal_code: 'M8V 1K8' }, { address: '3500 Lake Shore Boulevard West', city: 'Toronto', province: 'ON', postal_code: 'M8W 3H4' }, { address: '2264 Lake Shore Boulevard West', city: 'Toronto', province: 'ON', postal_code: 'M8V 0B1' }, { address: '69 Long Branch Avenue', city: 'Toronto', province: 'ON', postal_code: 'M8W 1P4' }, { address: '95 Mimico Avenue', city: 'Toronto', province: 'ON', postal_code: 'M8W 1R4' }, { address: '119 Mimico Avenue', city: 'Toronto', province: 'ON', postal_code: 'M8W 1R6' }, { address: '2 Orianna Drive', city: 'Toronto', province: 'ON', postal_code: 'M8W 4Y1' }, { address: '18 Ourland Avenue', city: 'Toronto', province: 'ON', postal_code: 'M8Z 4C8' }, { address: '80 Park Lawn Road', city: 'Toronto', province: 'ON', postal_code: 'M8Y 3H8' }, { address: '156 Sixth Street', city: 'Toronto', province: 'ON', postal_code: 'M8V 3A8' }, { address: '2 Station Road', city: 'Toronto', province: 'ON', postal_code: 'M8V 2R1' }, { address: '47 Station Road', city: 'Toronto', province: 'ON', postal_code: 'M8V 2R1' }, { address: '146 Thirtieth Street', city: 'Toronto', province: 'ON', postal_code: 'M8W 3C4' }, { address: '25 Whitlam Avenue', city: 'Toronto', province: 'ON', postal_code: 'M8V 2K2' }, { address: '995 Arrow Road', city: 'Toronto', province: 'ON', postal_code: 'M9M 2Z5' }, { address: '2990 Islington Avenue', city: 'Toronto', province: 'ON', postal_code: 'M9L 2K9' }, { address: '2100 Jane Street', city: 'Toronto', province: 'ON', postal_code: 'M3M 1A1' }, { address: '36 Loney Avenue', city: 'Toronto', province: 'ON', postal_code: 'M3L 1G3' }, { address: '69 Milvan Drive', city: 'Toronto', province: 'ON', postal_code: 'M9L 1Z1' }, { address: '2799 Weston Road', city: 'Toronto', province: 'ON', postal_code: 'M9M 2R9' }, { address: '3100 Weston Road', city: 'Toronto', province: 'ON', postal_code: 'M9M 2S7' }, { address: '1700 Wilson Avenue', city: 'Toronto', province: 'ON', postal_code: 'M3L 1B2' }, { address: '3962 Chesswood Drive', city: 'Toronto', province: 'ON', postal_code: 'M3J 2W6' }, { address: '4100 Chesswood Drive', city: 'Toronto', province: 'ON', postal_code: 'M3J 2B8' }, { address: '4340 Dufferin Street', city: 'Toronto', province: 'ON', postal_code: 'M3H 5R9' }]

50.times do
  full_address = SEED_ADDRESSES.sample
  Volunteer.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address: full_address[:address],
    city: full_address[:city],
    province: full_address[:province],
    postal_code: full_address[:postal_code]
  )
  Client.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address: full_address[:address],
    city: full_address[:city],
    province: full_address[:province],
    postal_code: full_address[:postal_code]
  )
end

15.times do
  Match.create(
    client_id: Client.order('RANDOM()').first.id,
    volunteer_id: Volunteer.order('RANDOM()').first.id,
    day: %w(monday tuesday wednesday thursday friday).sample,
    start_time: [9, 10, 11].sample,
    end_time: [12, 13, 14].sample)
end

100.times do
  Availability.create(
    volunteer_id: Volunteer.order('RANDOM()').first.id,
    start_time: [9, 10, 13].sample,
    end_time: [14, 16, 17].sample,
    day: %w(monday tuesday wednesday thursday friday saturday sunday).sample
  )
end

[
  'Expressive Arts',
  'Bereavement Support',
  'Healing Touch',
  'Therapeutic touch',
  'Reiki',
  'Reflexology',
  'Registered Massage Therapy',
  'Spiritual Support'
].each do |specialty_name|
  VolunteerSpecialty.create(name: specialty_name)
end

VolunteerSpecialty.all.each do |specialty|
  20.times do
    volunteer = Volunteer.order('RANDOM()').first
    volunteer.volunteer_specialties << specialty unless volunteer.volunteer_specialties.include?(specialty)
  end
end

10.times do
  match_proposal_params = ActionController::Parameters.new(
    day: %w(monday tuesday wednesday thursday friday).sample,
    start_time: [7, 8, 9].sample,
    end_time: [16, 18, 20].sample,
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

  MatchProposalCreationService.new(match_proposal_params)
end
