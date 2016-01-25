class MeetingsPresenter
  def initialize(meetings)
    @meetings = meetings
  end

  def upcoming_meeting_text
    meetings_list_text(
      "You have #{pluralize(@meetings.length, 'upcoming meeting')} in next 30 minutes: \n"
    )
  end

  def today_meetings_list
    meetings_list_text(
      "You have #{pluralize(@meetings.length, 'meeting')} due for today: \n"
    )
  end

  private
  def meetings_list_text(intro)
    meetings_list = []
    meetings_list << intro
    @meetings.map { |meeting|
      meetings_list << '1. ' + meeting.info["summary"] + ' ' + meeting.starts_at.strftime('%H:%M %p')
    }
    meetings_list.join("\n")
  end
end
