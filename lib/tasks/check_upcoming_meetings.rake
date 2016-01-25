desc "This task find upcoming meetings and notifies the concerned person"
task :check_upcoming_meetings => :environment do
  puts "Searching for upcoming meetings"
  CheckUpcomingMeetingJob.perform_later
  puts "done."
end
