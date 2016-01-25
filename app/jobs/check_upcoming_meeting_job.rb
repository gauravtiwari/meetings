class CheckUpcomingMeetingJob < ApplicationJob
  def perform
    ActiveRecord::Base.transaction do
      User.find_each do |user|
        if !user.office_closed? and user.upcoming_meetings?
          if user.slack_token.present?
            SlackClient.new(user.slack_token).post_message(
              user.slack_uid,
              MeetingsPresenter.new(user).upcoming_meeting_text
            )
          end
          if user.can_text?
            TwilioClient.new.send_message(
              user.phone,
              MeetingsPresenter.new(user).upcoming_meeting_text.gsub('\n', '%0a')
            )
          end
        end
      end
    end
  end
end
