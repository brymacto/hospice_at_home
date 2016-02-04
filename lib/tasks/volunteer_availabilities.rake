namespace :volunteer_availabilities do
  desc 'merges volunteer availabilities that are duplicate and bordering'
  task 'merge_availabilities' => :environment do
    volunteers = Volunteer.all
    availabilities_before_task = VolunteerAvailability.all.size
    volunteers.each do |volunteer|
      p "***** Merging for #{volunteer.name}"
      availabilities_before_merge = volunteer.volunteer_availabilities.size
      volunteer.merge_volunteer_availabilities
      availabilities_after_merge = volunteer.reload.volunteer_availabilities.size
      if availabilities_before_merge != availabilities_after_merge
        p "Volunteer availabilities before merge: #{availabilities_before_merge}. Volunteer availabilities after merge: #{availabilities_before_merge}"
      end
    end
    availabilities_after_task = VolunteerAvailability.all.size
    p "Volunteer availabilities before task: #{availabilities_before_task}"
    p "Volunteer availabilities after task: #{availabilities_after_task}"
  end
end
