class NotifyUpcomingMeetingJob < ApplicationJob
  def perform
    ActiveRecord::Base.transaction do
      User.find_each do |user|
        if user.upcoming_meeting? and user.can_text?
        end
      end
    end
  end
end
