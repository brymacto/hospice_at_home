namespace :volunteer_availabilities do
  desc 'merges volunteer availabilities that are duplicate and bordering'
  task 'merge_availabilities' => :environment do
    volunteers = Volunteer.all
    p "//////////////"
    p "Volunteer availabilities before task: #{VolunteerAvailability.all.size}"
    volunteers.each do |volunteer|
      p "***** Merging for #{volunteer.name}"
      p "Volunteer availabilities before merge: #{volunteer.volunteer_availabilities.size}"
      volunteer.merge_volunteer_availabilities
      p "Volunteer availabilities after merge: #{volunteer.reload.volunteer_availabilities.size}"
    end
    p "Volunteer availabilities after task: #{VolunteerAvailability.all.reload.size}"
  end
end
