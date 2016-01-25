class SendMeetingListToSlackJob < ApplicationJob
  def perform
    ActiveRecord::Base.transaction do
      User.find_each do |user|
        if user.slack_token.present?
          client = Slack::Web::Client.new
          client.token = user.slack_token
          client.chat_postMessage(channel: user.slack_uid, text: user.today_meetings_list, mrkdwn: true, as_user: false)
        end
      end
    end
  end
end
