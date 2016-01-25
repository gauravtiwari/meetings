desc "This task sends todays meeting list to concerned person"
task :send_meeting_list => :environment do
  puts "Sending today meeting list"
  SendMeetingListJob.perform_later
  puts "done."
end
