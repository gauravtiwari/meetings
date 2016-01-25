class FetchEventsJob < ApplicationJob
  def perform(user_id)
    ActiveRecord::Base.transaction do
      user = User.find_by(id: user_id)
      events = GoogleClient.new.fetch_events(user.from_time, user.google_token)
      events.items.each do |event|
        meeting =  Meeting.unscoped.where(meeting_id: event.id)
        if meeting.present?
          meeting.update(Meeting.meeting_attrs(event, user_id))
        else
          user.meetings.create(Meeting.meeting_attrs(event, user_id))
        end
      end
    end
  end
end
