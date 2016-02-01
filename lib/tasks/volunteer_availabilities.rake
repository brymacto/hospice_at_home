namespace :volunteer_availabilities do
  desc 'merges volunteer availabilities that are bordering'
  task 'merge_availabilities' => :environment do
    volunteers = Volunteer.all
    volunteers.each do |volunteer|
      p "***** Merging for #{volunteer.name}"
      p "Volunteer availabilities before merge: #{volunteer.volunteer_availabilities.size}"
      volunteer.merge_volunteer_availabilities
      p "Volunteer availabilities after merge: #{volunteer.reload.volunteer_availabilities.size}"
    end
  end
end
