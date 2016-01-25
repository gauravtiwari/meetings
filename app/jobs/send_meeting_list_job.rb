class SendMeetingListJob < ApplicationJob
  def perform
    ActiveRecord::Base.transaction do
      User.find_each do |user|
        if user.slack_token.present?
          SlackClient.new(user.slack_token).post_message(
            user.slack_uid, MeetingsPresenter.new(user.today_meetings)
          )
        end
      end
    end
  end
end
