class MeetingsPresenter
  include ActionView::Helpers
  def initialize(user)
    @user = user
  end

  def upcoming_meeting_text
    meetings_list_text(
      @user.upcoming_meetings,
      "#{@user.slack_uid}: You have #{pluralize(@user.upcoming_meetings.length, 'upcoming meeting')} in next 30 minutes: \n"
    )
  end

  def today_meetings_list_text
    meetings_list_text(
      @user.today_meetings,
      "#{@user.slack_uid}: You have #{pluralize(@user.today_meetings.length, 'meeting')} due for today: \n"
    )
  end

  private
  def meetings_list_text(meetings, intro)
    meetings_list = []
    meetings_list << intro
    meetings.map { |meeting|
      meetings_list << '1. ' + meeting.info["summary"] + ' ' + meeting.starts_at.strftime('%H:%M %p')
    }
    meetings_list.join("\n")
  end
end
